"
Unit tests verifying two-way synchronization, command recording, continuous typing coalescing, and diagram-only integration for OPDynamicForm.
"
Class {
	#name : 'OPPropertiesFormUndoTest',
	#superclass : 'TestCase',
	#instVars : [
		'undoManager',
		'form',
		'model',
		'viewModel'
	],
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}
