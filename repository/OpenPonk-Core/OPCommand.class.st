"
Abstract base command for all reversible operations in OpenPonk. Subclasses implement #execute, #undo, and optional coalescing.
"
Class {
	#name : 'OPCommand',
	#superclass : 'Object',
	#instVars : [
		'description'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'testing' }
OPCommand >> affectsModel [
	"Answer whether execution, undo, or redo of this command modifies the domain model structure or model properties."
	^ true
]

{ #category : 'enumerating' }
OPCommand >> allLeafDescriptionsDo: aBlockClosure [
	"Evaluate aBlockClosure with the description of this leaf command."
	aBlockClosure value: self description
]

{ #category : 'testing' }
OPCommand >> canCoalesceWith: aCommand [
	"Answer whether the receiver can absorb aCommand to optimize history."
	^ false
]

{ #category : 'testing' }
OPCommand >> canCoalesceWithPropertyChange: aPropertyChangeCommand [
	^ false
]

{ #category : 'actions' }
OPCommand >> coalesceWith: aCommand [
	"Absorb changes from aCommand into the receiver. Subclasses that answer true to #canCoalesceWith: must override this method."
	^ self shouldNotImplement
]

{ #category : 'accessing' }
OPCommand >> defaultDescription [
	| rawName |
	rawName := self class name asString.
	(rawName beginsWith: 'OP') ifTrue: [ rawName := rawName allButFirst: 2 ].
	(rawName endsWith: 'Command') ifTrue: [ rawName := rawName allButLast: 7 ].
	^ String streamContents: [ :stream |
		rawName doWithIndex: [ :char :index |
			(char isUppercase and: [ index > 1 ]) ifTrue: [ stream space ].
			stream nextPut: char ] ]
]

{ #category : 'accessing' }
OPCommand >> description [
	description ifNotNil: [ ^ description ].
	^ self defaultDescription
]

{ #category : 'accessing' }
OPCommand >> description: aString [
	description := aString
]

{ #category : 'executing' }
OPCommand >> execute [
	"Execute the command operation. Must be implemented by subclasses."
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPCommand >> firstLeafCommand [
	^ self
]

{ #category : 'testing' }
OPCommand >> isComposite [
	"Answer whether the receiver represents a composite sequence of commands."
	^ false
]

{ #category : 'accessing' }
OPCommand >> leafCount [
	^ 1
]

{ #category : 'executing' }
OPCommand >> redo [
	"Reapply the command changes. Defaults to invoking #execute."
	^ self execute
]

{ #category : 'executing' }
OPCommand >> undo [
	"Revert the changes performed by this command. Must be implemented by subclasses."
	^ self subclassResponsibility
]

{ #category : 'undo/redo' }
OPCommand >> undoDiagram [
	"Phase 2 of two-phase undo: synchronize diagrams and re-render."
	"Do nothing by default."
]

{ #category : 'undo/redo' }
OPCommand >> undoModel [
	"Phase 1 of two-phase undo: restore domain model state."
	^ self undo
]
