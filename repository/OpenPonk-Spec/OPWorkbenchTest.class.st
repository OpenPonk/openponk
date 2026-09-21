Class {
	#name : 'OPWorkbenchTest',
	#superclass : 'TestCase',
	#instVars : [
		'workbench'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPWorkbenchTest >> setUp [
	super setUp.
	workbench := OPWorkbench new
]

{ #category : 'running' }
OPWorkbenchTest >> tearDown [
	workbench ifNotNil: [
		workbench close.
		workbench := nil ].
	super tearDown
]

{ #category : 'tests' }
OPWorkbenchTest >> testInitialKeyboardFocusIsOnMenuBar [
	| window activeFocusMorph menuBarMorph |
	window := workbench open.
	activeFocusMorph := window adapter widget activeHand keyboardFocus.
	menuBarMorph := workbench topToolbar menu adapter widget.
	self assert: activeFocusMorph equals: menuBarMorph.
	self deny: activeFocusMorph equals: workbench topToolbar saveButton adapter widget
]

{ #category : 'tests' }
OPWorkbenchTest >> testPanesRetainWidthOnWorkbenchResize [

	| window initialTreeWidth initialFormWidth |
	workbench := OPWorkbench new.
	window := workbench open.
	window adapter widget extent: 1000 @ 700.
	window adapter widget fullBounds.

	initialTreeWidth := workbench projectTree adapter widget width.
	initialFormWidth := workbench form adapter widget width.

	self assert: initialTreeWidth equals: OPWorkbench initialListsWidth.
	"SpTabLayout applies a 10 px inset (5 px on each side) to its contents"
	self assert: initialFormWidth equals: OPWorkbench initialFormWidth - 10.

	"Resize open window morph horizontally by +400 px"
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
