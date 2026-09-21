"
Unit tests for OPUndoManager covering recording, undo, redo, capacity limits, reentrancy guards, isolated transactions, and announcements.
"
Class {
	#name : 'OPUndoManagerTest',
	#superclass : 'TestCase',
	#instVars : [
		'undoManager'
	],
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'running' }
OPUndoManagerTest >> setUp [

	super setUp.
	undoManager := OPUndoManager new
]

{ #category : 'tests' }
OPUndoManagerTest >> testAnnouncementOnRecordUndoRedoClear [

	| count |
	count := 0.
	undoManager announcer when: OPUndoRedoChanged do: [ count := count + 1 ] for: self.
	undoManager record: (OPUndoTestLoggingCommand log: OrderedCollection new value: 1).
	self assert: count equals: 1.
	undoManager undo.
	self assert: count equals: 2.
	undoManager redo.
	self assert: count equals: 3.
	undoManager clear.
	self assert: count equals: 4
]

{ #category : 'tests' }
OPUndoManagerTest >> testEmptyTransactionNotRecorded [
	undoManager inTransaction: [ "no-op" ].
	self assert: undoManager undoStack isEmpty.
	self deny: undoManager canUndo
]

{ #category : 'tests' }
OPUndoManagerTest >> testInTransactionLabeledSetsDescriptionOnCompositeCommand [
	| recordedCommand loggingCommand |
	loggingCommand := OPUndoTestLoggingCommand log: OrderedCollection new value: 1.
	undoManager inTransactionLabeled: 'Layout Diagram' do: [
		undoManager execute: loggingCommand ].
	self assert: undoManager undoStack size equals: 1.
	recordedCommand := undoManager undoStack last.
	self assert: recordedCommand description equals: 'Layout Diagram'
]

{ #category : 'tests' }
OPUndoManagerTest >> testMaxUndoSteps [

	undoManager maxUndoSteps: 3.
	1 to: 5 do: [ :i | undoManager record: (OPUndoTestLoggingCommand log: OrderedCollection new value: i) ].
	self assert: undoManager undoStack size equals: 3.
	undoManager undo.
	undoManager undo.
	undoManager undo.
	self deny: undoManager canUndo
]

{ #category : 'tests' }
OPUndoManagerTest >> testNestedTransactionRollbackIsolation [

	| target |
	target := OPUndoTestViewModel new.
	target name: 'Initial'.
	target value: 10.
	undoManager inTransaction: [
			target value: 20.
			undoManager record: (OPPropertyChangeCommand
					 viewModel: target
					 selector: #value
					 oldValue: 10
					 newValue: 20).
			[
				undoManager inTransaction: [
						target name: 'Changed'.
						undoManager record: (OPPropertyChangeCommand
								 viewModel: target
								 selector: #name
								 oldValue: 'Initial'
								 newValue: 'Changed').
						self error: 'Inner error' ] ]
				on: Error
				do: [ :ex | "inner error handled" ].
			target value: 30.
			undoManager record: (OPPropertyChangeCommand
					 viewModel: target
					 selector: #value
					 oldValue: 20
					 newValue: 30) ].
	self assert: target name equals: 'Initial'.
	self assert: target value equals: 30.
	self assert: undoManager undoStack size equals: 1.
	undoManager undo.
	self assert: target value equals: 10
]

{ #category : 'tests' }
OPUndoManagerTest >> testNestedTransactions [

	| log cmd1 cmd2 cmd3 cmd4 |
	log := OrderedCollection new.
	cmd1 := OPUndoTestLoggingCommand log: log value: 1.
	cmd2 := OPUndoTestLoggingCommand log: log value: 2.
	cmd3 := OPUndoTestLoggingCommand log: log value: 3.
	cmd4 := OPUndoTestLoggingCommand log: log value: 4.
	undoManager inTransaction: [
			undoManager record: cmd1.
			undoManager inTransaction: [
					undoManager record: cmd2.
					undoManager record: cmd3 ].
			undoManager record: cmd4 ].
	self assert: undoManager undoStack size equals: 1.
	undoManager undo.
	self assert: log asArray equals: #( 'undo:4' 'undo:3' 'undo:2' 'undo:1' )
]

{ #category : 'tests' }
OPUndoManagerTest >> testRecordSimpleCommand [

	| log cmd |
	log := OrderedCollection new.
	cmd := OPUndoTestLoggingCommand log: log value: 1.
	undoManager record: cmd.
	self assert: undoManager undoStack size equals: 1.
	self assert: undoManager redoStack isEmpty.
	self assert: undoManager canUndo.
	self deny: undoManager canRedo
]

{ #category : 'tests' }
OPUndoManagerTest >> testRedo [

	| log cmd |
	log := OrderedCollection new.
	cmd := OPUndoTestLoggingCommand log: log value: 1.
	undoManager record: cmd.
	undoManager undo.
	undoManager redo.
	self assert: log asArray equals: #( 'undo:1' 'redo:1' ).
	self assert: undoManager undoStack size equals: 1.
	self assert: undoManager redoStack isEmpty.
	self assert: undoManager canUndo.
	self deny: undoManager canRedo
]

{ #category : 'tests' }
OPUndoManagerTest >> testRedoStackClearedOnNewRecord [

	| log cmd1 cmd2 cmd3 |
	log := OrderedCollection new.
	cmd1 := OPUndoTestLoggingCommand log: log value: 1.
	cmd2 := OPUndoTestLoggingCommand log: log value: 2.
	cmd3 := OPUndoTestLoggingCommand log: log value: 3.
	undoManager record: cmd1.
	undoManager record: cmd2.
	undoManager undo.
	self assert: undoManager redoStack size equals: 1.
	undoManager record: cmd3.
	self assert: undoManager redoStack isEmpty.
	self assert: undoManager undoStack size equals: 2
]

{ #category : 'tests' }
OPUndoManagerTest >> testReentrancyGuard [

	| log nestedCmd reentrantCmd |
	log := OrderedCollection new.
	nestedCmd := OPUndoTestLoggingCommand log: log value: #nested.
	reentrantCmd := OPUndoTestReentrantCommand undoManager: undoManager nestedCommand: nestedCmd.
	undoManager record: reentrantCmd.
	self assert: undoManager undoStack size equals: 1.
	undoManager undo.
	self assert: undoManager undoStack isEmpty.
	self assert: undoManager redoStack size equals: 1.
	self assert: log isEmpty.
	self deny: undoManager isExecutingUndoRedo
]

{ #category : 'tests' }
OPUndoManagerTest >> testTransaction [

	| log cmd1 cmd2 |
	log := OrderedCollection new.
	cmd1 := OPUndoTestLoggingCommand log: log value: 1.
	cmd2 := OPUndoTestLoggingCommand log: log value: 2.
	undoManager inTransaction: [
			undoManager record: cmd1.
			undoManager record: cmd2 ].
	self assert: undoManager undoStack size equals: 1.
	self assert: undoManager undoStack first isComposite.
	self assert: undoManager undoStack first commands size equals: 2.
	undoManager undo.
	self assert: log asArray equals: #( 'undo:2' 'undo:1' )
]

{ #category : 'tests' }
OPUndoManagerTest >> testTransactionRollbackOnException [

	| target caught |
	target := OPUndoTestViewModel new.
	target name: 'Initial'.
	caught := false.
	[
		undoManager inTransaction: [
				target name: 'Step1'.
				undoManager record: (OPPropertyChangeCommand
						 viewModel: target
						 selector: #name
						 oldValue: 'Initial'
						 newValue: 'Step1').
				target name: 'Step2'.
				undoManager record: (OPPropertyChangeCommand
						 viewModel: target
						 selector: #name
						 oldValue: 'Step1'
						 newValue: 'Step2').
				self error: 'Simulation failure' ] ]
		on: Error
		do: [ :ex | caught := true ].
	self assert: caught.
	self assert: target name equals: 'Initial'.
	self assert: undoManager undoStack isEmpty.
	self assert: undoManager transactionStack isEmpty.
	self deny: undoManager isExecutingUndoRedo.
	self deny: undoManager canUndo
]

{ #category : 'tests' }
OPUndoManagerTest >> testUndo [

	| log cmd |
	log := OrderedCollection new.
	cmd := OPUndoTestLoggingCommand log: log value: 1.
	undoManager record: cmd.
	undoManager undo.
	self assert: log asArray equals: #( 'undo:1' ).
	self assert: undoManager undoStack isEmpty.
	self assert: undoManager redoStack size equals: 1.
	self deny: undoManager canUndo.
	self assert: undoManager canRedo
]

{ #category : 'tests' }
OPUndoManagerTest >> testUndoFailureDiscardsCommandAndClearsRedo [

	| failingCmd caught |
	failingCmd := OPUndoTestLoggingCommand log: OrderedCollection new value: #error.
	failingCmd class compile: 'undo self error: ''Intended undo crash'' '.
	undoManager record: failingCmd.
	self assert: undoManager undoStack size equals: 1.
	caught := false.
	[ undoManager undo ]
		on: Error
		do: [ :ex | caught := true ].
	self assert: caught.
	self assert: undoManager undoStack isEmpty.
	self assert: undoManager redoStack isEmpty.
	self deny: undoManager isExecutingUndoRedo.
	self deny: undoManager canUndo.
	failingCmd class compile: 'undo log add: (''undo:'' , value asString)'
]
