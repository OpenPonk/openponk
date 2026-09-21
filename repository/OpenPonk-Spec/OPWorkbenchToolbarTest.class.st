Class {
	#name : 'OPWorkbenchToolbarTest',
	#superclass : 'TestCase',
	#instVars : [
		'toolbarPresenter',
		'mockWorkbench',
		'mockProjectController',
		'mockUndoManager',
		'undoAnnouncer'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPWorkbenchToolbarTest >> setUp [
	super setUp.
	undoAnnouncer := Announcer new.
	mockUndoManager := Mock new.
	mockUndoManager stub announcer willReturn: undoAnnouncer.
	mockUndoManager stub canUndo willReturn: false.
	mockUndoManager stub canRedo willReturn: false.
	mockUndoManager stub undoStack willReturn: OrderedCollection new.
	mockUndoManager stub redoStack willReturn: OrderedCollection new.
	mockProjectController := Mock new.
	mockProjectController stub undoManager willReturn: mockUndoManager.
	mockWorkbench := Mock new.
	mockWorkbench stub projectController willReturn: mockProjectController.
	mockWorkbench stub workbench willReturn: mockWorkbench.
	toolbarPresenter := OPWorkbenchToolbar new.
	toolbarPresenter owner: mockWorkbench
]

{ #category : 'running' }
OPWorkbenchToolbarTest >> tearDown [
	toolbarPresenter := nil.
	mockWorkbench := nil.
	mockProjectController := nil.
	mockUndoManager := nil.
	undoAnnouncer := nil.
	super tearDown
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testArrowButtonsDisabledWhenNoProjectController [
	mockWorkbench stub projectController willReturn: nil.
	toolbarPresenter updateButtons.
	self deny: toolbarPresenter undoArrowButton isEnabled.
	self deny: toolbarPresenter redoArrowButton isEnabled
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testArrowButtonsExistAndHaveCorrectIcons [
	self assert: toolbarPresenter undoArrowButton isNotNil.
	self assert: toolbarPresenter redoArrowButton isNotNil.
	self assert: toolbarPresenter undoArrowButton icon equals: (toolbarPresenter iconNamed: #arrowDown).
	self assert: toolbarPresenter redoArrowButton icon equals: (toolbarPresenter iconNamed: #arrowDown)
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testButtonsDisabledWhenNoProjectController [
	mockWorkbench stub projectController willReturn: nil.
	toolbarPresenter updateButtons.
	self deny: toolbarPresenter saveButton isEnabled.
	self deny: toolbarPresenter undoButton isEnabled.
	self deny: toolbarPresenter redoButton isEnabled
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testButtonsExistAndHaveCorrectIcons [
	self assert: toolbarPresenter saveButton isNotNil.
	self assert: toolbarPresenter undoButton isNotNil.
	self assert: toolbarPresenter redoButton isNotNil.
	self assert: toolbarPresenter saveButton icon equals: (toolbarPresenter iconNamed: #smallSave).
	self assert: toolbarPresenter undoButton icon equals: (toolbarPresenter iconNamed: #smallUndo).
	self assert: toolbarPresenter redoButton icon equals: (toolbarPresenter iconNamed: #smallRedo)
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testButtonsReactToUndoRedoChangedAnnouncement [
	toolbarPresenter registerUndoRedoAnnouncements.
	mockUndoManager stub canUndo willReturn: true.
	mockUndoManager stub canRedo willReturn: false.
	undoAnnouncer announce: OPUndoRedoChanged new.
	self assert: toolbarPresenter undoButton isEnabled.
	self deny: toolbarPresenter redoButton isEnabled.

	mockUndoManager stub canUndo willReturn: false.
	mockUndoManager stub canRedo willReturn: true.
	undoAnnouncer announce: OPUndoRedoChanged new.
	self deny: toolbarPresenter undoButton isEnabled.
	self assert: toolbarPresenter redoButton isEnabled
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testFocusedEditorPreservesRigidLayoutConstraints [
	| testPlugin testEditor |
	toolbarPresenter owner: nil.
	toolbarPresenter application: SpApplication defaultApplication.
	testPlugin := OPTestPlugin new.
	testEditor := (OPEditor on: testPlugin)
		workbench: mockWorkbench;
		yourself.
	toolbarPresenter build.
	toolbarPresenter adapter widget height: 34.
	toolbarPresenter adapter widget vResizing: #rigid.

	toolbarPresenter focusedEditor: testEditor.
	self assert: toolbarPresenter adapter widget vResizing equals: #rigid.
	self assert: toolbarPresenter adapter widget height equals: 34.

	toolbarPresenter focusedEditor: nil.
	self assert: toolbarPresenter adapter widget vResizing equals: #rigid.
	self assert: toolbarPresenter adapter widget height equals: 34
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testFocusedEditorPreservesToolbarWidgetIdentity [
	| initialWidget testPlugin testEditor |
	toolbarPresenter owner: nil.
	toolbarPresenter application: SpApplication defaultApplication.
	testPlugin := OPTestPlugin new.
	testEditor := (OPEditor on: testPlugin)
		workbench: mockWorkbench;
		yourself.
	toolbarPresenter build.
	initialWidget := toolbarPresenter adapter widget.

	toolbarPresenter focusedEditor: testEditor.
	self assert: toolbarPresenter adapter widget identicalTo: initialWidget.

	toolbarPresenter focusedEditor: nil.
	self assert: toolbarPresenter adapter widget identicalTo: initialWidget
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testRedoButtonDelegatesToUndoManager [
	mockUndoManager stub redo willReturn: nil.
	toolbarPresenter redoButton performAction.
	mockUndoManager should receive redo
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testRedoHistoryItemRevertsMultipleSteps [
	| commandMock1 commandMock2 menu items |
	commandMock1 := Mock new.
	commandMock1 stub description willReturn: 'First Redo'.
	commandMock2 := Mock new.
	commandMock2 stub description willReturn: 'Second Redo'.
	mockUndoManager stub canRedo willReturn: true.
	mockUndoManager stub redoStack willReturn: (OrderedCollection with: commandMock1 with: commandMock2).
	mockUndoManager stub redo willReturn: nil.
	menu := toolbarPresenter redoHistoryMenu.
	items := menu menuGroups first menuItems.
	self assert: items size equals: 2.
	items second action value.
	mockUndoManager should receive redo twice
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testRedoHistoryMenuShowsRecentCommands [
	| commandMock menu items |
	commandMock := Mock new.
	commandMock stub description willReturn: 'Delete Box'.
	mockUndoManager stub canRedo willReturn: true.
	mockUndoManager stub redoStack willReturn: (OrderedCollection with: commandMock).
	menu := toolbarPresenter redoHistoryMenu.
	items := menu menuGroups first menuItems.
	self assert: items size equals: 1.
	self assert: items first name equals: '1. Delete Box'
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testSaveButtonDelegatesToWorkbench [
	mockWorkbench stub saveProject willReturn: nil.
	toolbarPresenter saveButton performAction.
	mockWorkbench should receive saveProject
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testUndoButtonDelegatesToUndoManager [
	mockUndoManager stub undo willReturn: nil.
	toolbarPresenter undoButton performAction.
	mockUndoManager should receive undo
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testUndoHistoryItemRevertsMultipleSteps [
	| commandMock1 commandMock2 menu items |
	commandMock1 := Mock new.
	commandMock1 stub description willReturn: 'First Action'.
	commandMock2 := Mock new.
	commandMock2 stub description willReturn: 'Second Action'.
	mockUndoManager stub canUndo willReturn: true.
	mockUndoManager stub undoStack willReturn: (OrderedCollection with: commandMock1 with: commandMock2).
	mockUndoManager stub undo willReturn: nil.
	menu := toolbarPresenter undoHistoryMenu.
	items := menu menuGroups first menuItems.
	self assert: items size equals: 2.
	items second action value.
	mockUndoManager should receive undo twice
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testUndoHistoryMenuShowsRecentCommands [
	| commandMock menu items |
	commandMock := Mock new.
	commandMock stub description willReturn: 'Move Element'.
	mockUndoManager stub canUndo willReturn: true.
	mockUndoManager stub undoStack willReturn: (OrderedCollection with: commandMock).
	menu := toolbarPresenter undoHistoryMenu.
	items := menu menuGroups first menuItems.
	self assert: items size equals: 1.
	self assert: items first name equals: '1. Move Element'
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testUndoRedoButtonsReflectUndoManagerCapabilities [
	mockUndoManager stub canUndo willReturn: true.
	mockUndoManager stub canRedo willReturn: false.
	toolbarPresenter updateButtons.
	self assert: toolbarPresenter saveButton isEnabled.
	self assert: toolbarPresenter undoButton isEnabled.
	self deny: toolbarPresenter redoButton isEnabled.

	mockUndoManager stub canUndo willReturn: false.
	mockUndoManager stub canRedo willReturn: true.
	toolbarPresenter updateButtons.
	self deny: toolbarPresenter undoButton isEnabled.
	self assert: toolbarPresenter redoButton isEnabled
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testUnsubscribeFromUndoManagerRemovesSubscriptions [
	toolbarPresenter registerUndoRedoAnnouncements.
	self assert: undoAnnouncer numberOfSubscriptions equals: 1.
	toolbarPresenter unsubscribeFromUndoManager.
	self assert: undoAnnouncer numberOfSubscriptions equals: 0
]
