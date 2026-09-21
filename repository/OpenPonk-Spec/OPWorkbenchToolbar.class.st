"
Spec presenter representing the top menu toolbar of the OPWorkbench. 
Dynamically manages project-level menu items and injects editor-specific actions based on the currently focused diagram.
"
Class {
	#name : 'OPWorkbenchToolbar',
	#superclass : 'SpPresenter',
	#instVars : [
		'saveButton',
		'undoButton',
		'undoArrowButton',
		'redoButton',
		'redoArrowButton',
		'undoPopover',
		'redoPopover',
		'lastUndoDismissTimestamp',
		'lastRedoDismissTimestamp',
		'focusedEditor',
		'menu'
	],
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'menus for editor' }
OPWorkbenchToolbar >> addDiagramMenu [

	self removeDiagramMenu.
	menu menuGroups first addItem: [ :item |
			item
				name: 'Diagram';
				icon: (self iconNamed: #objects);
				subMenu: self addDiagramMenuItems ].
	self updateMenu
]

{ #category : 'menus for editor' }
OPWorkbenchToolbar >> addDiagramMenuItems [

	| submenu |
	submenu := self newMenu.
	self
		addDiagramMenuItems: ((PragmaMenuBuilder pragmaKeyword: #opEditorToolbarMenu model: focusedEditor)
				 buildTree;
				 itemList)
		to: submenu.

	self
		addDiagramMenuItems: ((OPPragmaPluginMenuBuilder pragmaKeyword: #opEditorToolbarMenu: model: focusedEditor)
				 buildTree;
				 itemList)
		to: submenu.

	^ submenu
]

{ #category : 'menus for editor' }
OPWorkbenchToolbar >> addDiagramMenuItems: menuRegistrations to: spMenu [

	| itemEndingGroupIndex |
	menuRegistrations ifEmpty: [ ^ spMenu ].
	menuRegistrations last withSeparatorAfter.
	itemEndingGroupIndex := menuRegistrations size.
	spMenu addGroup: [ :group | 
		menuRegistrations withIndexDo: [ :each :index | 
			itemEndingGroupIndex >= index ifTrue: [ 
				group addItem: [ :item | 
					item
						name: each label;
						icon: each spec icon;
						action: [ :arg | 
							each spec action selector ifNotNil: [ 
									each spec action cull: arg ] ].
					(each itemList isNotNil and: [ each itemList isNotEmpty ]) 
						ifTrue: [ 
							| submenu |
							submenu := self newMenu.
							item subMenu: submenu.
							self addDiagramMenuItems: each itemList to: submenu ] ].
				each spec separator ifTrue: [ itemEndingGroupIndex := index ] ] ] ].
	^ self
		  addDiagramMenuItems:
		  (menuRegistrations allButFirst: itemEndingGroupIndex)
		  to: spMenu
]

{ #category : 'initialization' }
OPWorkbenchToolbar >> connectPresenters [

	menu
		autoRefresh: true;
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'OpenPonk';
						icon: (self iconNamed: #home);
						subMenu: self opMenu ];
				addItem: [ :item | 
					item
						name: 'Project';
						icon: (self iconNamed: #open);
						subMenu: self projectMenu ] ]
]

{ #category : 'api - focus' }
OPWorkbenchToolbar >> defaultKeyboardFocus [
	^ menu
]

{ #category : 'layout' }
OPWorkbenchToolbar >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: saveButton width: 28;
		  add: SpNullPresenter new width: 6;
		  add: undoButton width: 28;
		  add: undoArrowButton width: 16;
		  add: SpNullPresenter new width: 6;
		  add: redoButton width: 28;
		  add: redoArrowButton width: 16;
		  add: SpNullPresenter new width: 8;
		  add: menu;
		  yourself
]

{ #category : 'private' }
OPWorkbenchToolbar >> descriptionForCommand: aCommand atIndex: anInteger [
	| commandDescription |
	commandDescription := aCommand description.
	^ anInteger asString , '. ' , commandDescription
]

{ #category : 'menus for editor' }
OPWorkbenchToolbar >> focusedEditor: anEditor [

	focusedEditor := anEditor.
	focusedEditor ifNil: [ self removeDiagramMenu ] ifNotNil: [ self addDiagramMenu ].
	self updateMenu
]

{ #category : 'initialization' }
OPWorkbenchToolbar >> initializePresenters [

	super initializePresenters.
	lastUndoDismissTimestamp := 0.
	lastRedoDismissTimestamp := 0.

	menu := self newMenuBar.

	saveButton := self newButton.
	saveButton
		addStyle: 'flat';
		icon: (self iconNamed: #smallSave);
		help: 'Save Project';
		enabled: false;
		action: [ self saveProject ];
		whenBuiltDo: [ :anAdapter | anAdapter widget ifNotNil: [ :aWidget | aWidget layoutInset: 0 @ 0 ] ].

	undoButton := self newButton.
	undoButton
		addStyle: 'flat';
		icon: (self iconNamed: #smallUndo);
		help: 'Undo';
		enabled: false;
		action: [ self undo ];
		whenBuiltDo: [ :anAdapter | anAdapter widget ifNotNil: [ :aWidget | aWidget layoutInset: 0 @ 0 ] ].

	undoArrowButton := self newButton.
	undoArrowButton
		addStyle: 'flat';
		icon: (self iconNamed: #arrowDown);
		help: 'Undo history';
		enabled: false;
		action: [ self toggleUndoPopover ];
		whenBuiltDo: [ :anAdapter | anAdapter widget ifNotNil: [ :aWidget | aWidget layoutInset: 0 @ 0 ] ].

	undoPopover := self newPopover.
	undoPopover
		relativeTo: undoArrowButton;
		bePositionBottom;
		whenClosedDo: [ lastUndoDismissTimestamp := Time millisecondClockValue ].

	redoButton := self newButton.
	redoButton
		addStyle: 'flat';
		icon: (self iconNamed: #smallRedo);
		help: 'Redo';
		enabled: false;
		action: [ self redo ];
		whenBuiltDo: [ :anAdapter | anAdapter widget ifNotNil: [ :aWidget | aWidget layoutInset: 0 @ 0 ] ].

	redoArrowButton := self newButton.
	redoArrowButton
		addStyle: 'flat';
		icon: (self iconNamed: #arrowDown);
		help: 'Redo history';
		enabled: false;
		action: [ self toggleRedoPopover ];
		whenBuiltDo: [ :anAdapter | anAdapter widget ifNotNil: [ :aWidget | aWidget layoutInset: 0 @ 0 ] ].

	redoPopover := self newPopover.
	redoPopover
		relativeTo: redoArrowButton;
		bePositionBottom;
		whenClosedDo: [ lastRedoDismissTimestamp := Time millisecondClockValue ].

	self focusOrder
		add: saveButton;
		add: undoButton;
		add: undoArrowButton;
		add: redoButton;
		add: redoArrowButton;
		add: menu
]

{ #category : 'accessing - spec' }
OPWorkbenchToolbar >> menu [
	^ menu
]

{ #category : 'menus for project' }
OPWorkbenchToolbar >> opMenu [

	| menu browser path |
	menu := self newMenu.
	menu
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Settings';
						icon: (self iconNamed: #configuration);
						action: [ 
							browser := SettingBrowser new
								           changePackageSet: { #'OpenPonk-Spec' asPackage };
								           yourself.
							path := (browser open submorphs detect: [ :each | 
								         each isKindOf: MorphTreeMorph ]) nodeList.
							browser expandNodePath: path first contents first path ] ];
				addItem: [ :item | 
					item
						name: 'Check for new version';
						icon: (self iconNamed: #smallUpdate);
						action: [ 
							(OPVersionComparisonInfo newApplication: SpApplication defaultApplication)
								open ] ] ];
		addGroup: [ :group | 
			group addItem: [ :item | 
				item
					name: 'Close OpenPonk';
					icon: (self iconNamed: #smallQuit);
					action: [ WorldState saveAndQuit ] ] ].
	^ menu
]

{ #category : 'accessing' }
OPWorkbenchToolbar >> projectController [
	^ self workbench ifNotNil: [ :activeWorkbench | activeWorkbench projectController ]
]

{ #category : 'menus for project' }
OPWorkbenchToolbar >> projectMenu [
	| menu cmdMenu |
	menu := self newMenu.
	cmdMenu := OPWorkbenchActivation buildMenuInContext: (CmdSimpleToolContext for: self).
	cmdMenu buildSpecMenuOn: menu.
	^ menu
]

{ #category : 'actions' }
OPWorkbenchToolbar >> redo [
	self undoManager ifNotNil: [ :activeUndoManager | activeUndoManager redo ]
]

{ #category : 'accessing' }
OPWorkbenchToolbar >> redoArrowButton [
	^ redoArrowButton
]

{ #category : 'accessing' }
OPWorkbenchToolbar >> redoButton [
	^ redoButton
]

{ #category : 'menus' }
OPWorkbenchToolbar >> redoHistoryMenu [
	| historyMenu activeUndoManager recentCommands |
	historyMenu := self newMenu.
	activeUndoManager := self undoManager.
	(activeUndoManager isNil or: [ activeUndoManager canRedo not ]) ifTrue: [ ^ historyMenu ].
	recentCommands := (activeUndoManager redoStack last: (20 min: activeUndoManager redoStack size)) reversed.
	historyMenu addGroup: [ :group |
		recentCommands withIndexDo: [ :command :index |
			group addItem: [ :item |
				item
					name: (self descriptionForCommand: command atIndex: index);
					icon: (self iconNamed: #smallRedo);
					action: [
						redoPopover ifNotNil: #dismiss.
						self redoSteps: index ] ] ] ].
	^ historyMenu
]

{ #category : 'accessing' }
OPWorkbenchToolbar >> redoPopover [
	^ redoPopover
]

{ #category : 'actions' }
OPWorkbenchToolbar >> redoSteps: anInteger [
	| activeUndoManager |
	activeUndoManager := self undoManager.
	activeUndoManager ifNotNil: [
		anInteger timesRepeat: [ activeUndoManager redo ] ]
]

{ #category : 'initialization' }
OPWorkbenchToolbar >> registerUndoRedoAnnouncements [
	"Subscribe to project undo manager announcements, ensuring prior subscriptions are cleared."
	self unsubscribeFromUndoManager.
	self undoManager ifNotNil: [ :activeUndoManager |
		activeUndoManager announcer weak
			when: OPUndoRedoChanged
			send: #updateButtons
			to: self ].
	self updateButtons
]

{ #category : 'menus for editor' }
OPWorkbenchToolbar >> removeDiagramMenu [

	menu menuGroups first menuItems size > 2 ifTrue: [ menu menuGroups first menuItems removeLast ].
	self updateMenu
]

{ #category : 'accessing' }
OPWorkbenchToolbar >> saveButton [
	^ saveButton
]

{ #category : 'actions' }
OPWorkbenchToolbar >> saveProject [
	self workbench saveProject
]

{ #category : 'actions' }
OPWorkbenchToolbar >> toggleRedoPopover [
	| currentClock isVisible |
	currentClock := Time millisecondClockValue.
	isVisible := false.
	redoPopover withAdapterDo: [ :anAdapter |
		anAdapter widget ifNotNil: [ :aWidget |
			isVisible := aWidget isInWorld ] ].
	(isVisible or: [ (currentClock - lastRedoDismissTimestamp) < 250 ])
		ifTrue: [ redoPopover dismiss ]
		ifFalse: [
			redoPopover presenter: self redoHistoryMenu.
			redoPopover popup ]
]

{ #category : 'actions' }
OPWorkbenchToolbar >> toggleUndoPopover [
	| currentClock isVisible |
	currentClock := Time millisecondClockValue.
	isVisible := false.
	undoPopover withAdapterDo: [ :anAdapter |
		anAdapter widget ifNotNil: [ :aWidget |
			isVisible := aWidget isInWorld ] ].
	(isVisible or: [ (currentClock - lastUndoDismissTimestamp) < 250 ])
		ifTrue: [ undoPopover dismiss ]
		ifFalse: [
			undoPopover presenter: self undoHistoryMenu.
			undoPopover popup ]
]

{ #category : 'actions' }
OPWorkbenchToolbar >> undo [
	self undoManager ifNotNil: [ :activeUndoManager | activeUndoManager undo ]
]

{ #category : 'accessing' }
OPWorkbenchToolbar >> undoArrowButton [
	^ undoArrowButton
]

{ #category : 'accessing' }
OPWorkbenchToolbar >> undoButton [
	^ undoButton
]

{ #category : 'menus' }
OPWorkbenchToolbar >> undoHistoryMenu [
	| historyMenu activeUndoManager recentCommands |
	historyMenu := self newMenu.
	activeUndoManager := self undoManager.
	(activeUndoManager isNil or: [ activeUndoManager canUndo not ]) ifTrue: [ ^ historyMenu ].
	recentCommands := (activeUndoManager undoStack last: (20 min: activeUndoManager undoStack size)) reversed.
	historyMenu addGroup: [ :group |
		recentCommands withIndexDo: [ :command :index |
			group addItem: [ :item |
				item
					name: (self descriptionForCommand: command atIndex: index);
					icon: (self iconNamed: #smallUndo);
					action: [
						undoPopover ifNotNil: #dismiss.
						self undoSteps: index ] ] ] ].
	^ historyMenu
]

{ #category : 'accessing' }
OPWorkbenchToolbar >> undoManager [
	^ self projectController ifNotNil: [ :activeProjectController | activeProjectController undoManager ]
]

{ #category : 'accessing' }
OPWorkbenchToolbar >> undoPopover [
	^ undoPopover
]

{ #category : 'actions' }
OPWorkbenchToolbar >> undoSteps: anInteger [
	| activeUndoManager |
	activeUndoManager := self undoManager.
	activeUndoManager ifNotNil: [
		anInteger timesRepeat: [ activeUndoManager undo ] ]
]

{ #category : 'initialization' }
OPWorkbenchToolbar >> unsubscribeFromUndoManager [
	"Explicitly unsubscribe from active undo manager announcer to prevent memory leaks."
	self undoManager ifNotNil: [ :activeUndoManager |
		activeUndoManager announcer unsubscribe: self ]
]

{ #category : 'updating' }
OPWorkbenchToolbar >> updateButtons [
	| activeProjectController activeUndoManager canUndo canRedo |
	activeProjectController := self projectController.
	activeUndoManager := self undoManager.
	canUndo := activeUndoManager isNotNil and: [ activeUndoManager canUndo ].
	canRedo := activeUndoManager isNotNil and: [ activeUndoManager canRedo ].
	saveButton enabled: activeProjectController isNotNil.
	undoButton enabled: canUndo.
	undoArrowButton enabled: canUndo.
	redoButton enabled: canRedo.
	redoArrowButton enabled: canRedo
]

{ #category : 'updating' }
OPWorkbenchToolbar >> updateMenu [
	"Update the docking bar morph in-place to reflect menu item changes without rebuilding the toolbar presenter."
	menu withAdapterDo: [ :menuBarAdapter |
		menuBarAdapter widget ifNotNil: [ :dockingBarMorph |
			dockingBarMorph removeAllMorphs.
			menuBarAdapter menuGroups withIndexDo: [ :eachGroup :groupIndex |
				menuBarAdapter adoptMenuGroupModel: eachGroup first: groupIndex = 1 ] ] ]
]

{ #category : 'menus for project' }
OPWorkbenchToolbar >> updateProjectMenu [
	menu menuGroups first menuItems second subMenu: self projectMenu.
	self updateMenu
]

{ #category : 'accessing' }
OPWorkbenchToolbar >> workbench [
	^ self owner ifNotNil: [ :activeOwner | activeOwner workbench ]
]
