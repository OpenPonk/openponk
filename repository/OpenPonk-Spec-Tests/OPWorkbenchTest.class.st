"
Tests top-level workbench initialization, window layout, and active editor coordination.
"
Class {
	#name : 'OPWorkbenchTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench'
	],
	#category : 'OpenPonk-Spec-Tests-Windows',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Windows'
}

{ #category : 'running' }
OPWorkbenchTest >> setUp [
	super setUp.
	OPPluginRegistry setDefaultForTesting.
	workbench := OPWorkbench new
]

{ #category : 'running' }
OPWorkbenchTest >> tearDown [
	workbench ifNotNil: [
		workbench close.
		workbench := nil ].
	OPPluginRegistry resetDefault.
	super tearDown
]

{ #category : 'tests' }
OPWorkbenchTest >> testClassQueriesDevelopmentModeAndSettings [
	| originalDevMode |
	self assert: OPWorkbench initialSidePaneWidth equals: 250.
	self assert: OPWorkbench initialListsWidth equals: 250.
	self assert: OPWorkbench initialFormWidth equals: 250.
	self assert: OPWorkbench initialWidth equals: OPWorkbench initialExtent x.
	self assert: (OPWorkbench class includesSelector: #settingsOn:) description: 'settingsOn: must be defined'.
	self assert: (OPWorkbench class includesSelector: #developerSettingsOn:) description: 'developerSettingsOn: must be defined'.

	originalDevMode := OPWorkbench isDevelopmentMode.
	[
		OPWorkbench isDevelopmentMode: true.
		self assert: OPWorkbench isDevelopmentMode description: 'isDevelopmentMode should be true after setting'.
		OPWorkbench isDevelopmentMode: false.
		self deny: OPWorkbench isDevelopmentMode description: 'isDevelopmentMode should be false after resetting'
	] ensure: [ OPWorkbench isDevelopmentMode: originalDevMode ]
]

{ #category : 'tests' }
OPWorkbenchTest >> testInitialKeyboardFocusIsOnMenuBar [
	| window activeFocusMorph menuBarMorph mockProjectController mockProject |
	mockProjectController := Mock new.
	mockProject := Mock new.
	mockProjectController stub project willReturn: mockProject.
	workbench instVarNamed: 'projectController' put: mockProjectController.
	window := workbench open.
	activeFocusMorph := window adapter widget activeHand keyboardFocus.
	menuBarMorph := workbench topToolbar menu adapter widget.
	self assert: activeFocusMorph equals: menuBarMorph.
	self deny: activeFocusMorph equals: workbench topToolbar saveButton adapter widget
]

{ #category : 'tests' }
OPWorkbenchTest >> testOpenProjectEditorsLifecycleTabUpdatesAndDeletion [
	| project model diag1 diag2 secondRegistry editor1 editor2 page1 updatedProject updatedDiagram |
	self assert: workbench title equals: 'OpenPonk'.
	self assert: workbench projectController identicalTo: nil.
	self assert: workbench focusedEditor identicalTo: nil.

	secondRegistry := OPPluginRegistry new add: OPTestPlugin new; yourself.
	workbench pluginRegistry: secondRegistry.
	self assert: workbench pluginRegistry identicalTo: secondRegistry.

	project := OPProject name: 'Workbench Test Project'.
	model := OPTestContainerModel new name: 'RootPkg'; yourself.
	diag1 := (OPOpenPonkDiagram forModelElement: model) name: 'MainDiagram'; isOpen: true; isSelected: true; yourself.
	diag2 := (OPOpenPonkDiagram forModelElement: model) name: 'SecondDiagram'; isOpen: false; isSelected: false; yourself.
	project addModel: model.
	project addDiagram: diag1.
	project addDiagram: diag2.

	workbench openProject: project.
	self assert: workbench workbench identicalTo: workbench.
	self assert: workbench project identicalTo: project.
	self assert: workbench title equals: 'Workbench Test Project - OpenPonk'.

	project storageFile: FileSystem memory root / 'wb-test.opp'.
	workbench updateTitle.
	self assert: (workbench title includesSubstring: 'wb-test.opp') description: 'Title should include storage file path'.

	editor1 := workbench focusedEditor.
	self assert: editor1 isNotNil description: 'Opening project with open diagram should focus its editor'.
	page1 := workbench pageFor: diag1.
	self assert: page1 isNotNil description: 'pageFor: should return notebook page for opened diagram'.
	self assert: (workbench pageFor: diag2) identicalTo: nil.

	workbench openEditorOn: model.
	self assert: workbench focusedEditor identicalTo: editor1.

	editor2 := workbench openEditorOnDiagram: diag2.
	self assert: workbench focusedEditor identicalTo: editor2.
	workbench focusEditorOf: diag1.
	self assert: workbench focusedEditor identicalTo: editor1.

	diag1 name: 'RenamedDiagram'.
	workbench updateTabTitle.
	self assert: (page1 title includesSubstring: 'RenamedDiagram') description: 'updateTabTitle should refresh notebook tab title'.

	workbench openFormOn: editor1 diagramController.
	workbench openFormOn: nil.

	workbench closeEditorOfDiagram: diag2.
	self assert: (workbench pageFor: diag2) identicalTo: nil.

	workbench deleteDiagram: diag2.
	self deny: (project diagrams includes: diag2) description: 'deleteDiagram: should remove diagram from project'.

	updatedProject := false.
	updatedDiagram := false.
	workbench when: OPEditorClosed do: [ updatedDiagram := true ] for: self.
	workbench closeEditorOfDiagram: diag1.
	self assert: updatedDiagram description: 'Closing editor tab should announce OPEditorClosed'
]

{ #category : 'tests' }
OPWorkbenchTest >> testPanesRetainWidthOnWorkbenchResize [

	| window initialTreeWidth initialFormWidth mockProjectController mockProject |
	mockProjectController := Mock new.
	mockProject := Mock new.
	mockProjectController stub project willReturn: mockProject.
	workbench instVarNamed: 'projectController' put: mockProjectController.
	window := workbench open.
	window adapter widget extent: 1000 @ 700.
	window adapter widget fullBounds.

	initialTreeWidth := workbench projectTree adapter widget width.
	initialFormWidth := workbench form adapter widget width.

	self assert: initialTreeWidth equals: OPWorkbench initialListsWidth.
	self assert: initialFormWidth equals: OPWorkbench initialFormWidth - 10.

	window adapter widget extent: 1400 @ 700.
	window adapter widget fullBounds.

	self assert: workbench projectTree adapter widget width equals: initialTreeWidth.

	self assert: workbench form adapter widget width equals: initialFormWidth
]

{ #category : 'tests' }
OPWorkbenchTest >> testRedoShortcutDelegatesToUndoManager [
	| mockProjectController mockUndoManager windowPresenter redoAction |
	workbench := OPWorkbench new.
	mockProjectController := Mock new.
	mockUndoManager := Mock new.
	mockProjectController stub undoManager willReturn: mockUndoManager.
	mockUndoManager stub canRedo willReturn: true.
	mockUndoManager stub redo willReturn: nil.
	workbench instVarNamed: 'projectController' put: mockProjectController.

	windowPresenter := workbench asWindow.
	[
		redoAction := windowPresenter actions allCommands
			detect: [ :eachAction |
				eachAction shortcutKey = $y actionModifier
					or: [ eachAction shortcutKey = $z shift actionModifier ] ]
			ifNone: [ nil ].

		self assert: redoAction isNotNil description: 'Redo action must be registered on window'.
		self assert: redoAction canBeExecuted description: 'Redo action must be enabled when canRedo is true'.
		redoAction execute.
		mockUndoManager should receive redo
	] ensure: [ windowPresenter close ]
]

{ #category : 'tests' }
OPWorkbenchTest >> testRenameProjectDialogAndOpenModelAndOpenFromFile [
	| project model openedWb mockRequest capturedAccept mockOpenPresenter capturedOpenBlock archiveFile sourceProject sourceCtrl openedFromFileWb |
	capturedAccept := nil.
	capturedOpenBlock := nil.
	project := OPProject name: 'Before Rename'.
	model := OPTestContainerModel new name: 'ModelA'; yourself.
	project addModel: model.
	workbench openProject: project.

	mockRequest := Mock new.
	SpRequestDialog stub new willReturn: mockRequest.
	mockRequest stub title: Any.
	mockRequest stub message: Any.
	mockRequest stub text: Any.
	mockRequest stub validateAnswer: Any.
	mockRequest stub onAccept: [ :block | capturedAccept := block ].
	mockRequest stub openDialog.
	mockRequest stub text willReturn: '  After Rename  '.

	workbench renameProject.
	capturedAccept value.
	self assert: project name equals: 'After Rename'.

	openedWb := OPWorkbench openModel: (OPTestContainerModel new name: 'StandaloneModel'; yourself).
	[
		self assert: openedWb project name equals: 'New Project'.
		self assert: openedWb project models size equals: 1
	] ensure: [ openedWb ifNotNil: [ openedWb close ] ].

	sourceProject := OPProject name: 'FromFile Project'.
	sourceProject addModel: (OPTestContainerModel new name: 'FileModel'; yourself).
	sourceProject ensureModelsHaveDiagrams.
	sourceCtrl := OPProjectController forProject: sourceProject.
	archiveFile := FileSystem memory root / 'wb-open-from-file.opp'.
	sourceCtrl saveProjectTo: archiveFile.

	mockOpenPresenter := Mock new.
	StOpenFilePresenter stub new willReturn: mockOpenPresenter.
	mockOpenPresenter stub title: Any.
	mockOpenPresenter stub extensions: Any named: Any.
	mockOpenPresenter stub okAction: [ :block | capturedOpenBlock := block ].
	mockOpenPresenter stub open.

	OPProjectController openFromFile.
	openedFromFileWb := capturedOpenBlock value: archiveFile.
	[
		self assert: openedFromFileWb project name equals: 'FromFile Project'
	] ensure: [ openedFromFileWb ifNotNil: [ openedFromFileWb close ] ]
]

{ #category : 'tests' }
OPWorkbenchTest >> testSaveProjectDelegatesToProjectController [
	| mockProjectController windowPresenter saveAction |
	workbench := OPWorkbench new.

	"Verify that saving without a controller fails explicitly"
	self should: [ workbench saveProject ] raise: AssertionFailure.

	mockProjectController := OPWorkbenchMockProjectController new.
	workbench instVarNamed: 'projectController' put: mockProjectController.

	windowPresenter := workbench asWindow.
	[
		saveAction := windowPresenter actions allCommands
			detect: [ :eachAction | eachAction shortcutKey = $s actionModifier ]
			ifNone: [ nil ].

		self assert: saveAction isNotNil description: 'Save shortcut action should be registered on window'.
		self assert: saveAction canBeExecuted description: 'Save action should be enabled when projectController is present'.

		saveAction execute.
		self assert: mockProjectController isSaved description: 'Executing save action must delegate to projectController saveProject'
	] ensure: [ windowPresenter close ]
]

{ #category : 'tests' }
OPWorkbenchTest >> testSaveProjectShortcutIsRegistered [
	| windowPresenter saveAction |
	workbench := OPWorkbench new.
	windowPresenter := workbench asWindow.
	[
		saveAction := windowPresenter actions allCommands
			detect: [ :eachAction | eachAction shortcutKey = $s actionModifier ]
			ifNone: [ nil ].

		self assert: saveAction isNotNil description: 'Save shortcut action should be registered on window'.
		self deny: saveAction canBeExecuted description: 'Save action must be disabled when projectController is nil'
	] ensure: [ windowPresenter close ]
]

{ #category : 'tests' }
OPWorkbenchTest >> testShowAllElementsClearsUndoManager [
	| testProject testProjectController activeUndoManager testCommand |
	workbench := OPWorkbench new.
	testProject := OPProject new.
	testProjectController := OPProjectController new.
	testProjectController project: testProject.
	workbench instVarNamed: 'projectController' put: testProjectController.

	activeUndoManager := testProjectController undoManager.
	testCommand := OPUndoTestLoggingCommand new.
	(testCommand respondsTo: #log:)
		ifTrue: [ testCommand log: OrderedCollection new ]
		ifFalse: [
			(testCommand class respondsTo: #log:)
				ifTrue: [ testCommand := OPUndoTestLoggingCommand log: OrderedCollection new ]
				ifFalse: [ testCommand instVarNamed: 'log' put: OrderedCollection new ] ].

	activeUndoManager inTransaction: [
		activeUndoManager execute: testCommand ].

	self assert: activeUndoManager canUndo
		description: 'UndoManager should contain commands before showAll'.

	workbench showAllElementsInAllDiagrams.

	self deny: activeUndoManager canUndo
		description: 'UndoManager must be cleared after showAllElementsInAllDiagrams'
]

{ #category : 'tests' }
OPWorkbenchTest >> testUndoRedoShortcutsAreRegisteredOnWindow [
	| windowPresenter windowMorph windowKeymaps registeredShortcuts |
	workbench := OPWorkbench new.
	windowPresenter := workbench asWindow.
	windowMorph := windowPresenter build.

	windowKeymaps := windowMorph kmDispatcher directKeymaps.
	registeredShortcuts := windowKeymaps keymaps collect: #shortcut.

	[
		self assert: (registeredShortcuts anySatisfy: [ :eachShortcut |
			eachShortcut matches: { (KeyboardEvent new
				setType: #keyDown
				buttons: (OSPlatform current isMacOS ifTrue: [ 64 ] ifFalse: [ 16 ])
				position: 0 @ 0
				keyValue: $z asciiValue
				charCode: $z asciiValue
				hand: self currentWorld activeHand
				stamp: 0;
				key: (KeyboardKey fromCharacter: $z);
				yourself) } ])
			description: 'Undo shortcut Ctrl+Z must be installed into SpWindowMorph key dispatcher'.

		self assert: (registeredShortcuts anySatisfy: [ :eachShortcut |
			eachShortcut matches: { (KeyboardEvent new
				setType: #keyDown
				buttons: (OSPlatform current isMacOS ifTrue: [ 64 ] ifFalse: [ 16 ])
				position: 0 @ 0
				keyValue: $s asciiValue
				charCode: $s asciiValue
				hand: self currentWorld activeHand
				stamp: 0;
				key: (KeyboardKey fromCharacter: $s);
				yourself) } ])
			description: 'Save shortcut Ctrl+S must be installed into SpWindowMorph key dispatcher'.

		self assert: (registeredShortcuts anySatisfy: [ :eachShortcut |
			eachShortcut matches: { (KeyboardEvent new
				setType: #keyDown
				buttons: (OSPlatform current isMacOS ifTrue: [ 64 ] ifFalse: [ 16 ])
				position: 0 @ 0
				keyValue: $y asciiValue
				charCode: $y asciiValue
				hand: self currentWorld activeHand
				stamp: 0;
				key: (KeyboardKey fromCharacter: $y);
				yourself) } ])
			description: 'Redo shortcut Ctrl+Y must be installed into SpWindowMorph key dispatcher'
	] ensure: [ windowPresenter close ]
]

{ #category : 'tests' }
OPWorkbenchTest >> testUndoShortcutDelegatesToUndoManager [
	| mockProjectController mockUndoManager windowPresenter undoAction |
	workbench := OPWorkbench new.
	mockProjectController := Mock new.
	mockUndoManager := Mock new.
	mockProjectController stub undoManager willReturn: mockUndoManager.
	mockUndoManager stub canUndo willReturn: true.
	mockUndoManager stub undo willReturn: nil.
	workbench instVarNamed: 'projectController' put: mockProjectController.

	windowPresenter := workbench asWindow.
	[
		undoAction := windowPresenter actions allCommands
			detect: [ :eachAction | eachAction shortcutKey = $z actionModifier ]
			ifNone: [ nil ].

		self assert: undoAction isNotNil description: 'Undo action must be registered on window'.
		self assert: undoAction canBeExecuted description: 'Undo action must be enabled when canUndo is true'.
		undoAction execute.
		mockUndoManager should receive undo
	] ensure: [ windowPresenter close ]
]

{ #category : 'tests' }
OPWorkbenchTest >> testUndoShortcutOnWindowExecutesUndoManager [
	| windowPresenter windowMorph mockProjectController mockUndoManager keyEvent |
	workbench := OPWorkbench new.
	mockProjectController := Mock new.
	mockUndoManager := Mock new.
	mockProjectController stub undoManager willReturn: mockUndoManager.
	mockUndoManager stub canUndo willReturn: true.
	mockUndoManager stub undo willReturn: nil.
	workbench instVarNamed: 'projectController' put: mockProjectController.

	windowPresenter := workbench asWindow.
	windowMorph := windowPresenter build.

	keyEvent := KeyboardEvent new
		setType: #keyDown
		buttons: (OSPlatform current isMacOS ifTrue: [ 64 ] ifFalse: [ 16 ])
		position: 0 @ 0
		keyValue: $z asciiValue
		charCode: $z asciiValue
		hand: self currentWorld activeHand
		stamp: 0;
		key: (KeyboardKey fromCharacter: $z);
		yourself.

	[
		windowMorph handleKeyDown: keyEvent.
		mockUndoManager should receive undo
	] ensure: [ windowPresenter close ]
]

{ #category : 'tests' }
OPWorkbenchTest >> testWorkbenchWindowIsMaximizedWhenOpened [

	| windowPresenter mockProjectController mockProject |
	mockProjectController := Mock new.
	mockProject := Mock new.
	mockProjectController stub project willReturn: mockProject.
	workbench instVarNamed: 'projectController' put: mockProjectController.
	windowPresenter := workbench open.
	self assert: windowPresenter isMaximized description: 'Workbench window must be maximized upon opening'
]

{ #category : 'tests' }
OPWorkbenchTest >> testZoomerSettingsRegisteredUnderOpenPonk [
	| method pragma |
	self assert: (OPWorkbench class includesSelector: #zoomerSettingsOn:)
		description: 'OPWorkbench class must define #zoomerSettingsOn:'.
	method := OPWorkbench class >> #zoomerSettingsOn:.
	pragma := method pragmaAt: #systemsettings.
	self assert: pragma isNotNil
		description: 'OPWorkbench class must declare #zoomerSettingsOn: with <systemsettings>'.
	self assert: (method sourceCode includesSubstring: 'parent: #openponk')
		description: 'Zoomer setting in OPWorkbench must be registered under #openponk'.
	self assert: (method sourceCode includesSubstring: 'target: OPZoomer')
		description: 'Zoomer setting in OPWorkbench must target OPZoomer'
]
