"
Unit tests verifying OPPropertyChangeCommand execution, reversibility, target normalization, and coalescing rules.
"
Class {
	#name : 'OPPropertyChangeCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'undoManager',
		'target'
	],
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'running' }
OPPropertyChangeCommandTest >> setUp [

	super setUp.
	undoManager := OPUndoManager new.
	target := OPUndoTestViewModel new.
	target name: 'Original'
]

{ #category : 'tests' }
OPPropertyChangeCommandTest >> testCoalescingClearsRedoStackInManager [

	| cmd1 cmd2 cmdToUndo |
	cmdToUndo := OPUndoTestLoggingCommand log: OrderedCollection new value: 99.
	undoManager record: cmdToUndo.
	undoManager undo.
	self assert: undoManager redoStack size equals: 1.

	cmd1 := OPPropertyChangeCommand
		        viewModel: target
		        selector: #name
		        oldValue: 'Original'
		        newValue: 'Draft'.
	undoManager record: cmd1.
	self assert: undoManager redoStack isEmpty.

	cmd2 := OPPropertyChangeCommand
		        viewModel: target
		        selector: #name
		        oldValue: 'Draft'
		        newValue: 'Final'.
	undoManager record: cmd2.
	self assert: undoManager redoStack isEmpty.
	self assert: undoManager undoStack size equals: 1.
	self assert: undoManager undoStack first newValue equals: 'Final'
]

{ #category : 'tests' }
OPPropertyChangeCommandTest >> testCoalescingWithinTimeout [

	| cmd1 cmd2 |
	cmd1 := OPPropertyChangeCommand
		        viewModel: target
		        selector: #name
		        oldValue: 'Original'
		        newValue: 'Draft'.
	cmd2 := OPPropertyChangeCommand
		        viewModel: target
		        selector: #name
		        oldValue: 'Draft'
		        newValue: 'Final'.
	self assert: (cmd1 canCoalesceWith: cmd2).
	cmd1 coalesceWith: cmd2.
	self assert: cmd1 oldValue equals: 'Original'.
	self assert: cmd1 newValue equals: 'Final'.
	self assert: cmd1 timestamp equals: cmd2 timestamp
]

{ #category : 'tests' }
OPPropertyChangeCommandTest >> testExecuteAndUndo [

	| cmd |
	cmd := OPPropertyChangeCommand
		       viewModel: target
		       selector: #name
		       oldValue: 'Original'
		       newValue: 'Changed'.
	cmd execute.
	self assert: target name equals: 'Changed'.
	cmd undo.
	self assert: target name equals: 'Original'.
	cmd redo.
	self assert: target name equals: 'Changed'
]

{ #category : 'tests' }
OPPropertyChangeCommandTest >> testNoCoalescingAfterTimeout [

	| cmd1 cmd2 |
	cmd1 := OPPropertyChangeCommand
		        viewModel: target
		        selector: #name
		        oldValue: 'Original'
		        newValue: 'Draft'.
	cmd1 timestamp: DateAndTime now - 2 seconds.
	cmd2 := OPPropertyChangeCommand
		        viewModel: target
		        selector: #name
		        oldValue: 'Draft'
		        newValue: 'Final'.
	self deny: (cmd1 canCoalesceWith: cmd2)
]

{ #category : 'tests' }
OPPropertyChangeCommandTest >> testNoCoalescingDifferentSelectors [

	| cmd1 cmd2 |
	cmd1 := OPPropertyChangeCommand
		        viewModel: target
		        selector: #name
		        oldValue: 'A'
		        newValue: 'B'.
	cmd2 := OPPropertyChangeCommand
		        viewModel: target
		        selector: #description
		        oldValue: 'B'
		        newValue: 'C'.
	self deny: (cmd1 canCoalesceWith: cmd2)
]

{ #category : 'tests' }
OPPropertyChangeCommandTest >> testNoCoalescingDifferentTargets [

	| otherTarget cmd1 cmd2 |
	otherTarget := OPUndoTestViewModel new.
	cmd1 := OPPropertyChangeCommand
		        viewModel: target
		        selector: #name
		        oldValue: 'A'
		        newValue: 'B'.
	cmd2 := OPPropertyChangeCommand
		        viewModel: otherTarget
		        selector: #name
		        oldValue: 'B'
		        newValue: 'C'.
	self deny: (cmd1 canCoalesceWith: cmd2)
]
