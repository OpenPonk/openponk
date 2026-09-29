"
Test command attempting to record new commands into OPUndoManager during undo/redo execution to verify reentrancy guard.
"
Class {
	#name : 'OPUndoTestReentrantCommand',
	#superclass : 'OPCommand',
	#instVars : [
		'undoManager',
		'nestedCommand',
		'executed'
	],
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'as yet unclassified' }
OPUndoTestReentrantCommand class >> undoManager: aManager nestedCommand: aCommand [
	^ self new
		undoManager: aManager;
		nestedCommand: aCommand;
		yourself
]

{ #category : 'executing' }
OPUndoTestReentrantCommand >> execute [
	executed := true
]

{ #category : 'accessing' }
OPUndoTestReentrantCommand >> nestedCommand: aCommand [
	nestedCommand := aCommand
]

{ #category : 'executing' }
OPUndoTestReentrantCommand >> redo [
	undoManager record: nestedCommand
]

{ #category : 'executing' }
OPUndoTestReentrantCommand >> undo [
	undoManager record: nestedCommand
]

{ #category : 'accessing' }
OPUndoTestReentrantCommand >> undoManager: aManager [
	undoManager := aManager
]
