Class {
	#name : 'OPUndoTestFailingCommand',
	#superclass : 'OPCommand',
	#category : 'OpenPonk-Core-Tests-UndoRedo',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'UndoRedo'
}

{ #category : 'executing' }
OPUndoTestFailingCommand >> execute [
	"No-op execution for test setup."
]

{ #category : 'executing' }
OPUndoTestFailingCommand >> undo [
	"Intentionally fail during undo to verify undo manager error isolation."
	self error: 'Intended undo crash'
]
