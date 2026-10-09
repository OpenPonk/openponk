"
Verifies the toolbar presenter lifecycle, dynamic menu updates, and Commander 1 menu building in the workbench toolbar.
"
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
	toolbarPresenter := OPWorkbenchToolbar newApplication: SpApplication defaultApplication.
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
OPWorkbenchToolbarTest >> testDiagramCommandsPrepareExecutionInCanvasContext [
	"Verifies that all diagram canvas commands accept the canvas presenter tool in prepareFullExecutionInContext: without DNU #tool."
	| testEditor mockDiagramController context commandClasses |
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.
	mockDiagramController := Mock new.
	mockDiagramController stub layouter willReturn: Mock new.
	testEditor canvasPresenter instVarNamed: 'diagramController' put: mockDiagramController.

	context := CmdSimpleToolContext for: testEditor canvasPresenter.
	commandClasses := OPDiagramCanvasCommand allSubclasses reject: #isAbstract.
	commandClasses do: [ :eachCommandClass |
		| command |
		command := eachCommandClass new.
		context prepareFullExecutionOf: command ]
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testDiagramMenuContainsCommanderActivations [
	"Verifies that the Diagram menu is populated by Commander activations (Show/Hide Elements and Layout)."
	| testEditor diagramMenuItem subMenuLabels |
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.

	toolbarPresenter focusedEditor: testEditor.
	diagramMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachMenuItem | eachMenuItem name = 'Diagram' ].
	subMenuLabels := diagramMenuItem subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems collect: [ :eachItem | eachItem name ] ].

	self assertCollection: subMenuLabels includesAll: #( 'Show/Hide Elements' 'Layout' )
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testDiagramMenuContainsExportAndInspectCommanderCommands [
	"Verifies that the Diagram menu is 100% Commander 1 and includes Export submenu and Inspect Controller."
	| testEditor diagramMenuItem subMenuLabels |
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.

	toolbarPresenter focusedEditor: testEditor.
	diagramMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachMenuItem | eachMenuItem name = 'Diagram' ].
	subMenuLabels := diagramMenuItem subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems collect: [ :eachItem | eachItem name ] ].

	self assertCollection: subMenuLabels includesAll: #( 'Show/Hide Elements' 'Layout' 'Export diagram as...' 'Inspect Controller...' )
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testDiagramMenuItemActionExecutesWithoutError [
	"Verifies that clicking a diagram menu item executes its Commander activator without MessageNotUnderstood."
	| testEditor mockDiagramController diagramMenuItem showHideItem |
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.
	mockDiagramController := Mock new.
	mockDiagramController stub layouter willReturn: Mock new.
	testEditor canvasPresenter instVarNamed: 'diagramController' put: mockDiagramController.

	toolbarPresenter focusedEditor: testEditor.
	diagramMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachMenuItem | eachMenuItem name = 'Diagram' ].
	showHideItem := diagramMenuItem subMenu menuGroups first menuItems
		detect: [ :eachItem | eachItem name = 'Show/Hide Elements' ].

	self assert: showHideItem action isNotNil
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testFocusedEditorAddsModelAndDiagramMenus [
	"Verifies that focusing an editor adds both Model and Diagram menus, resulting in 4 categories."
	| testEditor menuNames |
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.

	toolbarPresenter focusedEditor: testEditor.
	menuNames := toolbarPresenter menu menuGroups first menuItems collect: [ :eachMenuItem | eachMenuItem name ].

	self assert: menuNames asArray equals: #( 'OpenPonk' 'Project' 'Model' 'Diagram' )
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
OPWorkbenchToolbarTest >> testFocusedEditorResetRemovesEditorMenus [
	"Verifies that resetting focused editor to nil leaves only OpenPonk and Project menus."
	| testEditor menuNames |
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.

	toolbarPresenter focusedEditor: testEditor.
	toolbarPresenter focusedEditor: nil.
	menuNames := toolbarPresenter menu menuGroups first menuItems collect: [ :eachMenuItem | eachMenuItem name ].

	self assert: menuNames asArray equals: #( 'OpenPonk' 'Project' )
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testModelCommandsPrepareExecutionInEditorContext [
	"Verifies that all model commands accept the focused editor in prepareFullExecutionInContext:."
	| testEditor context commandClasses |
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.

	context := CmdSimpleToolContext for: testEditor.
	commandClasses := OPModelCommand allSubclasses reject: #isAbstract.
	commandClasses do: [ :eachCommandClass |
		| command |
		command := eachCommandClass new.
		context prepareFullExecutionOf: command ]
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testModelMenuDoesNotContainInactiveMenuGroupsWhenEditorDoesNotSupportThem [
	"Verifies that non-inlined groups are not rendered when their commands are inactive."
	| testEditor modelMenuItem subMenuLabels |
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.

	toolbarPresenter focusedEditor: testEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachMenuItem | eachMenuItem name = 'Model' ].
	subMenuLabels := modelMenuItem subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems collect: [ :eachItem | eachItem name ] ].

	self deny: (subMenuLabels includes: 'Test Inactive Group')
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testModelMenuItemActionExecutesWithoutError [
	"Verifies that an active model menu item action is wired to its Commander activator."
	| testEditor modelMenuItem allMenuItems testActionItem |
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.

	toolbarPresenter focusedEditor: testEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachTopMenuItem | eachTopMenuItem name = 'Model' ].
	allMenuItems := modelMenuItem subMenu menuGroups
		flatCollect: [ :eachTopGroup | eachTopGroup menuItems ].
	testActionItem := allMenuItems detect: [ :eachActionCandidate | eachActionCandidate name = 'Test Model Action' ].

	self assert: testActionItem action isNotNil
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testModelMenuItemIsDisabledWhenFocusedEditorHasNoModelCommands [
	"Verifies that the Model menu item is disabled (grayed out) when the active editor has no model commands."
	| testEditor modelMenuItem |
	testEditor := (OPEditor on: OPTestSecondaryPlugin new)
		workbench: mockWorkbench;
		yourself.

	toolbarPresenter focusedEditor: testEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachMenuItem | eachMenuItem name = 'Model' ].

	self deny: modelMenuItem isEnabled
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testModelMenuItemIsEnabledWhenFocusedEditorHasModelCommands [
	"Verifies that the Model menu item is enabled when the active editor has model commands."
	| testEditor modelMenuItem |
	testEditor := (OPEditor on: OPTestPlugin new)
		workbench: mockWorkbench;
		yourself.

	toolbarPresenter focusedEditor: testEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachMenuItem | eachMenuItem name = 'Model' ].

	self assert: modelMenuItem isEnabled
]

{ #category : 'tests' }
OPWorkbenchToolbarTest >> testOpenPonkMenuItemIsFirstWithSeparator [
	| toolbarPresenter openponkMenu firstGroup firstItem |
	toolbarPresenter := OPWorkbenchToolbar new.
	openponkMenu := toolbarPresenter openponkMenu.
	self assert: openponkMenu menuGroups size equals: 3.
	firstGroup := openponkMenu menuGroups first.
	self assert: firstGroup menuItems size equals: 1.
	firstItem := firstGroup menuItems first.
	self assert: firstItem name equals: 'New project'.
	self assert: firstItem icon bits equals: OPCoreIcons openponkIcon bits
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
