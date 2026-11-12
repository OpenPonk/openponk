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
	#category : 'OpenPonk-Spec-Tests-Form',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Form'
}

{ #category : 'running' }
OPPropertiesFormUndoTest >> setUp [
	super setUp.
	undoManager := OPUndoManager new.
	form := OPPropertiesForm new.
	form undoManager: undoManager.
	model := OPFormTestModel new.
	viewModel := OPFormTestViewModel forModel: model.
	form viewModel: viewModel
]

{ #category : 'tests' }
OPPropertiesFormUndoTest >> testBindCheckboxUndoRedo [
	| checkboxPresenter |
	checkboxPresenter := form bindings second presenter.
	self
		deny: checkboxPresenter state
		description: 'Checkbox presenter should initially be unchecked'.

	checkboxPresenter state: true.
	self
		assert: model isActive
		description: 'Checking checkbox should set model isActive to true'.
	self
		assert: undoManager canUndo
		description: 'Toggling checkbox should record an undoable command'.

	undoManager undo.
	self
		deny: model isActive
		description: 'Undoing checkbox change should restore model isActive to false'.
	self
		deny: checkboxPresenter state
		description: 'Undoing checkbox change should uncheck the checkbox presenter'.

	undoManager redo.
	self
		assert: model isActive
		description: 'Redoing checkbox change should set model isActive to true again'.
	self
		assert: checkboxPresenter state
		description: 'Redoing checkbox change should check the checkbox presenter again'
]

{ #category : 'tests' }
OPPropertiesFormUndoTest >> testBindTextInputUndoRedo [
	| textPresenter |
	textPresenter := form bindings first presenter.
	self assert: textPresenter text equals: 'Initial'.

	textPresenter text: 'FirstEdit'.
	self assert: model name equals: 'FirstEdit'.
	self
		assert: undoManager canUndo
		description: 'Editing bound text input should record an undoable command'.

	undoManager undo.
	self assert: model name equals: 'Initial'.
	self assert: textPresenter text equals: 'Initial'.

	undoManager redo.
	self assert: model name equals: 'FirstEdit'.
	self assert: textPresenter text equals: 'FirstEdit'
]

{ #category : 'tests' }
OPPropertiesFormUndoTest >> testContinuousTypingCoalescingInForm [
	| textPresenter command |
	textPresenter := form bindings first presenter.

	textPresenter text: 'Step 1'.
	textPresenter text: 'Step 12'.
	textPresenter text: 'Step 123'.

	self assert: model name equals: 'Step 123'.
	self assert: undoManager undoStack size equals: 1.
	command := undoManager undoStack first.
	self assert: command oldValue equals: 'Initial'.
	self assert: command newValue equals: 'Step 123'.

	undoManager undo.
	self assert: model name equals: 'Initial'.
	self assert: textPresenter text equals: 'Initial'.

	undoManager redo.
	self assert: model name equals: 'Step 123'.
	self assert: textPresenter text equals: 'Step 123'
]

{ #category : 'tests' }
OPPropertiesFormUndoTest >> testDiagramOnlyElementNoteUndoRedo [
	| note noteViewModel noteForm textPresenter |
	note := OPNote new text: 'Sticky Note'.
	noteViewModel := OPNoteViewModel forModel: note.
	noteForm := OPPropertiesForm new.
	noteForm undoManager: undoManager.
	noteForm viewModel: noteViewModel.

	textPresenter := noteForm bindings first presenter.
	self assert: textPresenter text equals: 'Sticky Note'.

	textPresenter text: 'Modified Note'.
	self assert: note text equals: 'Modified Note'.

	undoManager undo.
	self assert: note text equals: 'Sticky Note'.
	self assert: textPresenter text equals: 'Sticky Note'.

	undoManager redo.
	self assert: note text equals: 'Modified Note'.
	self assert: textPresenter text equals: 'Modified Note'
]

{ #category : 'tests' }
OPPropertiesFormUndoTest >> testUpdateBoundValuesDoesNotResetPresenterWhenValueUnchanged [
	| textPresenter |
	textPresenter := form bindings first presenter.
	textPresenter text: 'DirectTyping'.
	form updateBoundValues.
	self assert: textPresenter text equals: 'DirectTyping'
]
