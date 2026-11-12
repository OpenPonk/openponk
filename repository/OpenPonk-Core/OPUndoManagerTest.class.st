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
	self assertEmpty: undoManager undoStack.
	self
		deny: undoManager canUndo
		description: 'Empty transaction must not leave an undoable command on stack'
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
	self
		deny: undoManager canUndo
		description: 'Undo stack should be exhausted after undoing maxUndoSteps commands'
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
	self assertEmpty: undoManager redoStack.
	self
		assert: undoManager canUndo
		description: 'Undo manager should allow undo after recording a command'.
	self
		deny: undoManager canRedo
		description: 'Undo manager must not allow redo right after recording a new command'
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
	self assertEmpty: undoManager redoStack.
	self
		assert: undoManager canUndo
		description: 'Undo manager should allow undo after redoing a command'.
	self
		deny: undoManager canRedo
		description: 'Redo stack should be empty after redoing the only command'
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
	self assertEmpty: undoManager redoStack.
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
	self assertEmpty: undoManager undoStack.
	self assert: undoManager redoStack size equals: 1.
	self assertEmpty: log.
	self
		deny: undoManager isExecutingUndoRedo
		description: 'isExecutingUndoRedo flag must be reset after undo completes'
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
	self
		assert: undoManager undoStack first isComposite
		description: 'Commands recorded inside a transaction should be grouped into a composite command'.
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
	self
		assert: caught
		description: 'Exception signaled inside transaction should be re-signaled after rollback'.
	self assert: target name equals: 'Initial'.
	self assertEmpty: undoManager undoStack.
	self assertEmpty: undoManager transactionStack.
	self
		deny: undoManager isExecutingUndoRedo
		description: 'isExecutingUndoRedo flag must be false after transaction rollback'.
	self
		deny: undoManager canUndo
		description: 'Rolled back transaction must not leave commands on undoStack'
]

{ #category : 'tests' }
OPUndoManagerTest >> testUndo [
	| log cmd |
	log := OrderedCollection new.
	cmd := OPUndoTestLoggingCommand log: log value: 1.
	undoManager record: cmd.
	undoManager undo.
	self assert: log asArray equals: #( 'undo:1' ).
	self assertEmpty: undoManager undoStack.
	self assert: undoManager redoStack size equals: 1.
	self
		deny: undoManager canUndo
		description: 'Undo stack should be empty after undoing the only command'.
	self
		assert: undoManager canRedo
		description: 'Redo should be available after undoing a command'
]

{ #category : 'tests' }
OPUndoManagerTest >> testUndoFailureDiscardsCommandAndClearsRedo [
	| failingCommand caughtException |
	failingCommand := OPUndoTestFailingCommand new.
	undoManager record: failingCommand.
	self assert: undoManager undoStack size equals: 1.
	caughtException := false.
	[ undoManager undo ]
		on: Error
		do: [ :anException | caughtException := true ].
	self
		assert: caughtException
		description: 'Failing undo command should propagate the error'.
	self assertEmpty: undoManager undoStack.
	self assertEmpty: undoManager redoStack.
	self
		deny: undoManager isExecutingUndoRedo
		description: 'isExecutingUndoRedo must be reset even when undo fails'.
	self
		deny: undoManager canUndo
		description: 'Failed undo command must be discarded from undoStack'
]
