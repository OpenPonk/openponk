"
Groups multiple commands into a single transactional unit. Executes and redoes subcommands in FIFO order, and undoes them in LIFO order.
"
Class {
	#name : 'OPCompositeCommand',
	#superclass : 'OPCommand',
	#instVars : [
		'commands'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'as yet unclassified' }
OPCompositeCommand class >> with: aCommand [
	"Instantiate a composite command containing a single initial command."
	^ self new
		add: aCommand;
		yourself
]

{ #category : 'as yet unclassified' }
OPCompositeCommand class >> withAll: aCollection [
	"Instantiate a composite command containing all commands in aCollection."
	^ self new
		addAll: aCollection;
		yourself
]

{ #category : 'adding' }
OPCompositeCommand >> add: aCommand [
	"Add aCommand to the end of the composite sequence."
	commands add: aCommand.
	^ aCommand
]

{ #category : 'adding' }
OPCompositeCommand >> addAll: aCollection [
	"Add all commands from aCollection to the end of the composite sequence."
	commands addAll: aCollection.
	^ aCollection
]

{ #category : 'enumerating' }
OPCompositeCommand >> allLeafDescriptionsDo: aBlockClosure [
	"Evaluate aBlockClosure recursively on all enclosed leaf command descriptions."
	commands do: [ :eachCommand | eachCommand allLeafDescriptionsDo: aBlockClosure ]
]

{ #category : 'accessing' }
OPCompositeCommand >> commands [
	"Answer the collection of child commands."
	^ commands
]

{ #category : 'accessing' }
OPCompositeCommand >> defaultDescription [
	"Answer a human-readable description: (N) for homogeneous actions, (+N-1) for heterogeneous actions."
	| firstLeaf totalLeaves firstDescription allSame |
	firstLeaf := self firstLeafCommand.
	firstLeaf ifNil: [ ^ 'Empty' ].
	totalLeaves := self leafCount.
	totalLeaves = 1 ifTrue: [ ^ firstLeaf description ].
	firstDescription := firstLeaf description.
	allSame := true.
	self allLeafDescriptionsDo: [ :eachDescription |
		allSame ifTrue: [
			eachDescription = firstDescription ifFalse: [ allSame := false ] ] ].
	^ allSame
		ifTrue: [ firstDescription , ' (' , totalLeaves asString , ')' ]
		ifFalse: [ firstDescription , ' (+' , (totalLeaves - 1) asString , ')' ]
]

{ #category : 'executing' }
OPCompositeCommand >> execute [
	"Execute all child commands in FIFO order."
	commands do: [ :each | each execute ]
]

{ #category : 'accessing' }
OPCompositeCommand >> firstLeafCommand [
	commands ifEmpty: [ ^ nil ].
	^ commands first firstLeafCommand
]

{ #category : 'initialization' }
OPCompositeCommand >> initialize [
	super initialize.
	commands := OrderedCollection new
]

{ #category : 'testing' }
OPCompositeCommand >> isComposite [
	^ true
]

{ #category : 'testing' }
OPCompositeCommand >> isEmpty [
	^ commands isEmpty
]

{ #category : 'testing' }
OPCompositeCommand >> isNotEmpty [
	^ commands isNotEmpty
]

{ #category : 'accessing' }
OPCompositeCommand >> leafCount [
	^ commands sum: [ :eachCommand | eachCommand leafCount ] ifEmpty: [ 0 ]
]

{ #category : 'executing' }
OPCompositeCommand >> redo [
	"Redo all child commands in FIFO order."
	commands do: [ :each | each redo ]
]

{ #category : 'accessing' }
OPCompositeCommand >> size [
	^ commands size
]

{ #category : 'undo/redo' }
OPCompositeCommand >> undo [
	self undoModel.
	self undoDiagram
]

{ #category : 'undo/redo' }
OPCompositeCommand >> undoDiagram [
	"Phase 2: Diagram synchronization once the entire model is consistent."
	commands do: [ :each | each undoDiagram ]
]

{ #category : 'undo/redo' }
OPCompositeCommand >> undoModel [
	"Phase 1: Domain model restoration in strict LIFO order."
	commands reverseDo: [ :each | each undoModel ]
]
