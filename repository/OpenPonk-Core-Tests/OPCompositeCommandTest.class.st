"
Unit tests verifying OPCompositeCommand execution order (FIFO), undo order (LIFO), and bidirectional reversibility.
"
Class {
	#name : 'OPCompositeCommandTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests-UndoRedo',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'UndoRedo'
}

{ #category : 'tests' }
OPCompositeCommandTest >> testBidirectionalReversibility [

	| target cmd1 cmd2 composite |
	target := OPUndoTestViewModel new.
	target value: 0.
	cmd1 := OPPropertyChangeCommand
		        viewModel: target
		        selector: #value
		        oldValue: 0
		        newValue: 10.
	cmd2 := OPPropertyChangeCommand
		        viewModel: target
		        selector: #value
		        oldValue: 10
		        newValue: 25.
	composite := OPCompositeCommand withAll: {
			             cmd1.
			             cmd2 }.
	composite execute.
	self assert: target value equals: 25.
	composite undo.
	self assert: target value equals: 0.
	composite redo.
	self assert: target value equals: 25.
	composite undo.
	self assert: target value equals: 0
]

{ #category : 'tests' }
OPCompositeCommandTest >> testDefaultDescriptionUsesFirstLeafAndCount [
	| root inner cmd1 cmd2 |
	root := OPCompositeCommand new.
	inner := OPCompositeCommand new.
	cmd1 := OPCommand new description: 'Move Element'.
	cmd2 := OPCommand new description: 'Move Element'.
	inner add: cmd1; add: cmd2.
	root add: inner.

	self assert: root description equals: 'Move Element (2)'
]

{ #category : 'tests' }
OPCompositeCommandTest >> testDefaultDescriptionUsesFirstLeafAndCountWhenDifferent [
	| root inner cmd1 cmd2 |
	root := OPCompositeCommand new.
	inner := OPCompositeCommand new.
	cmd1 := OPCommand new description: 'Move Element'.
	cmd2 := OPCommand new description: 'Adjust Waypoint'.
	inner add: cmd1; add: cmd2.
	root add: inner.

	self assert: root description equals: 'Move Element (+1)'
]

{ #category : 'tests' }
OPCompositeCommandTest >> testExecutionFIFO [

	| log composite |
	log := OrderedCollection new.
	composite := OPCompositeCommand withAll: {
			             (OPUndoTestLoggingCommand log: log value: 1).
			             (OPUndoTestLoggingCommand log: log value: 2).
			             (OPUndoTestLoggingCommand log: log value: 3) }.
	composite execute.
	self assert: log asArray equals: #( 'execute:1' 'execute:2' 'execute:3' )
]

{ #category : 'tests' }
OPCompositeCommandTest >> testExplicitDescriptionOverridesDefaultDescription [
	| root cmd1 |
	root := OPCompositeCommand new.
	cmd1 := OPCommand new description: 'Move Element'.
	root add: cmd1.
	root description: 'Apply Layout'.

	self assert: root description equals: 'Apply Layout'
]

{ #category : 'tests' }
OPCompositeCommandTest >> testFirstLeafCommandRecursivelyFindsFirstAction [
	| root inner1 inner2 cmd1 cmd2 |
	root := OPCompositeCommand new.
	inner1 := OPCompositeCommand new.
	inner2 := OPCompositeCommand new.
	cmd1 := OPUndoTestLoggingCommand log: OrderedCollection new value: 1.
	cmd2 := OPUndoTestLoggingCommand log: OrderedCollection new value: 2.
	inner2 add: cmd1.
	inner1 add: inner2; add: cmd2.
	root add: inner1.

	self assert: root firstLeafCommand equals: cmd1
]

{ #category : 'tests' }
OPCompositeCommandTest >> testFirstLeafCommandSkipsLeadingEmptyNestedComposite [

	| root emptyInner leafCommand |
	root := OPCompositeCommand new.
	emptyInner := OPCompositeCommand new.
	leafCommand := OPCommand new description: 'Move Element'.
	root
		add: emptyInner;
		add: leafCommand.

	self assert: root firstLeafCommand identicalTo: leafCommand.
	self assert: root description equals: 'Move Element'
]

{ #category : 'tests' }
OPCompositeCommandTest >> testLeafCountRecursivelySumsAllAtomicCommands [
	| root inner1 inner2 cmd1 cmd2 cmd3 |
	root := OPCompositeCommand new.
	inner1 := OPCompositeCommand new.
	inner2 := OPCompositeCommand new.
	cmd1 := OPUndoTestLoggingCommand log: OrderedCollection new value: 1.
	cmd2 := OPUndoTestLoggingCommand log: OrderedCollection new value: 2.
	cmd3 := OPUndoTestLoggingCommand log: OrderedCollection new value: 3.
	inner2 add: cmd1; add: cmd2.
	inner1 add: inner2.
	root add: inner1; add: cmd3.

	self assert: root leafCount equals: 3
]

{ #category : 'tests' }
OPCompositeCommandTest >> testRedoFIFO [

	| log composite |
	log := OrderedCollection new.
	composite := OPCompositeCommand withAll: {
			             (OPUndoTestLoggingCommand log: log value: 1).
			             (OPUndoTestLoggingCommand log: log value: 2) }.
	composite redo.
	self assert: log asArray equals: #( 'redo:1' 'redo:2' )
]

{ #category : 'tests' }
OPCompositeCommandTest >> testUndoLIFO [

	| log composite |
	log := OrderedCollection new.
	composite := OPCompositeCommand withAll: {
			             (OPUndoTestLoggingCommand log: log value: 1).
			             (OPUndoTestLoggingCommand log: log value: 2).
			             (OPUndoTestLoggingCommand log: log value: 3) }.
	composite undo.
	self assert: log asArray equals: #( 'undo:3' 'undo:2' 'undo:1' )
]

{ #category : 'tests' }
OPCompositeCommandTest >> testWithSingleCommandAndEmptyQueries [

	| emptyComposite singleCommand singleComposite |
	emptyComposite := OPCompositeCommand new.
	self assert: emptyComposite isEmpty description: 'New composite command should be empty'.
	self assert: emptyComposite size equals: 0.
	self assert: emptyComposite leafCount equals: 0.
	self assert: emptyComposite firstLeafCommand identicalTo: nil.
	self assert: emptyComposite isComposite description: 'Composite command must report isComposite = true'.

	singleCommand := OPUndoTestLoggingCommand log: OrderedCollection new value: 1.
	singleComposite := OPCompositeCommand with: singleCommand.
	self deny: singleComposite isEmpty description: 'Composite created with a command must not be empty'.
	self assert: singleComposite size equals: 1.
	self assert: singleComposite firstLeafCommand identicalTo: singleCommand
]
