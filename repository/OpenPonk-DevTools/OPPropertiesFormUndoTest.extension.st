Extension { #name : 'OPPropertiesFormUndoTest' }

{ #category : '*OpenPonk-DevTools' }
OPPropertiesFormUndoTest >> setUp [

	super setUp.
	undoManager := OPUndoManager new.
	form := OPPropertiesForm new.
	form undoManager: undoManager.
	model := OPFormTestModel new.
	viewModel := OPFormTestViewModel forModel: model.
	form viewModel: viewModel
]

{ #category : '*OpenPonk-DevTools' }
OPPropertiesFormUndoTest >> testBindCheckboxUndoRedo [

	| checkboxPresenter |
	checkboxPresenter := form bindings second presenter.
	self deny: checkboxPresenter state.

	checkboxPresenter state: true.
	self assert: model isActive.
	self assert: undoManager canUndo.

	undoManager undo.
	self deny: model isActive.
	self deny: checkboxPresenter state.

	undoManager redo.
	self assert: model isActive.
	self assert: checkboxPresenter state
]

{ #category : '*OpenPonk-DevTools' }
OPPropertiesFormUndoTest >> testBindTextInputUndoRedo [
	| textPresenter |
	textPresenter := form bindings first presenter.
	self assert: textPresenter text equals: 'Initial'.

	textPresenter text: 'FirstEdit'.
	self assert: model name equals: 'FirstEdit'.
	self assert: undoManager canUndo.

	undoManager undo.
	self assert: model name equals: 'Initial'.
	self assert: textPresenter text equals: 'Initial'.

	undoManager redo.
	self assert: model name equals: 'FirstEdit'.
	self assert: textPresenter text equals: 'FirstEdit'
]

{ #category : '*OpenPonk-DevTools' }
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

{ #category : '*OpenPonk-DevTools' }
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

{ #category : '*OpenPonk-DevTools' }
OPPropertiesFormUndoTest >> testUpdateBoundValuesDoesNotResetPresenterWhenValueUnchanged [
	| textPresenter |
	textPresenter := form bindings first presenter.
	textPresenter text: 'DirectTyping'.
	form updateBoundValues.
	self assert: textPresenter text equals: 'DirectTyping'
]
