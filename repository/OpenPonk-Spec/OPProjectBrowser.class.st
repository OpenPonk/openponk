"
I am a window with listing of all existing DCProjects and a simple interface for manipulating them (creating, removing, opening, ...)

[[[
DCProjectBrowser open
]]]
"
Class {
	#name : #OPProjectBrowser,
	#superclass : #ComposablePresenter,
	#instVars : [
		'recentLabel',
		'recentList',
		'quickStartLabel',
		'projectNameInput',
		'pluginRegistry',
		'diagramOptions',
		'createProjectButton',
		'openProjectButton'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #specs }
OPProjectBrowser class >> addDiagramButtons: aSpecLayout [
	OPPluginRegistry default
		pluginsDo: [ :each | 
			aSpecLayout
				add: (each simpleName , 'Radio') asSymbol
				height: self buttonHeight ]
]

{ #category : #specs }
OPProjectBrowser class >> defaultSpec [
	^ SpecLayout composed
		newRow:
				[ :row | 
			row
				newColumn:
						[ :col | 
					col
						add: #recentLabel height: self buttonHeight;
						add: #recentList ];
				newColumn:
						[ :col | 
					col add: #quickStartLabel height: self buttonHeight.
					col add: #projectNameInput height: self buttonHeight.
					self addDiagramButtons: col.
					col add: #createProjectButton height: self buttonHeight.
					col add: #openProjectButton height: self buttonHeight.
					col newRow: [ :r |  ] ] ];
		yourself
]

{ #category : #'world menu' }
OPProjectBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #OpenPonk)
		icon: OPIcons current openponkIcon;
		action: [ self open ];
		withSeparatorAfter;
		order: 200
]

{ #category : #'instance creation' }
OPProjectBrowser class >> open [
	<script>
	^ self new openWithSpec
]

{ #category : #'as yet unclassified' }
OPProjectBrowser >> createProject [
	| project |
	project := OPProject named: projectNameInput text.
	diagramOptions values
		detect: [ :each | each second state ]
		ifFound: [ :each | 
			project
				addModel:
					(each first newModel
						name: projectNameInput text;
						yourself) ].
	self openProject: project
]

{ #category : #'accessing - spec' }
OPProjectBrowser >> createProjectButton [
	^ createProjectButton
]

{ #category : #'accessing - spec' }
OPProjectBrowser >> doesNotUnderstand: aMessage [
	^ (diagramOptions at: aMessage selector ifAbsent: [ super doesNotUnderstand: aMessage ])
		second
]

{ #category : #api }
OPProjectBrowser >> initialExtent [
	^ 400 @ 400
]

{ #category : #initialization }
OPProjectBrowser >> initialize [
	diagramOptions := Dictionary new.
	pluginRegistry := OPPluginRegistry default.
	super initialize
]

{ #category : #initialization }
OPProjectBrowser >> initializePresenter [
	super initializePresenter.
	recentList
		items: OPProjectStorage default projects;
		displayBlock: [ :each | each name ];
		doubleClickAction: [ self openProjectFromFile: recentList selectedItem storageFile ];
		handlesDoubleClick: true;
		menu: [ :menu | self projectMenu: menu for: recentList selectedItem ].
	projectNameInput
		autoAccept: true;
		whenTextChanged: [ :newValue | createProjectButton enabled: newValue isNotEmpty ].
	createProjectButton action: [ self createProject ].
	openProjectButton action: [ self openProjectFromFile ]
]

{ #category : #initialization }
OPProjectBrowser >> initializeWidgets [
	recentLabel := self newLabel label: 'Recent Projects'.
	recentList := self instantiate: FastTableModel.
	quickStartLabel := self newLabel label: 'Quick Start'.
	projectNameInput := self newTextInput text: 'New Project'.
	createProjectButton := self newButton label: 'Create Project'.
	openProjectButton := self newButton label: 'Open Project...'.
	pluginRegistry
		pluginsDo: [ :each | 
			(diagramOptions
				at: (each simpleName , 'Radio') asSymbol
				put: (Array with: each with: (self newRadioButton label: each name)))
				second whenBuiltDo: [ :event | event model widget hSpaceFill ] ].
	self setGroup
]

{ #category : #'project handling' }
OPProjectBrowser >> openProject: project [
	project saveInImage.
	project open.
	self delete
]

{ #category : #'accessing - spec' }
OPProjectBrowser >> openProjectButton [
	^ openProjectButton
]

{ #category : #'as yet unclassified' }
OPProjectBrowser >> openProjectFromDirectory [
	| folder |
	folder := UIManager default chooseDirectory: 'Choose directory containing the project'.
	folder ifNil: [ ^ self ].
	self openProject: (OPProjectDirectoryMaterializer new loadProjectFrom: folder)
]

{ #category : #'as yet unclassified' }
OPProjectBrowser >> openProjectFromFile [
	FDOpenFileDialog new
		whenSelected: [ :file | self openProjectFromFile: file ];
		extensionFilters:
			{'OpenPonk projects' -> #('opp').
			'All files' -> #()};
		defaultFolder: FileLocator imageDirectory asFileReference;
		title: 'Select an OpenPonk project...';
		open
]

{ #category : #'project handling' }
OPProjectBrowser >> openProjectFromFile: aFile [
	| reader newProject store |
	store := OPZipPersistence new loadFrom: aFile.
	reader := OPProjectDirectoryMaterializer new.
	newProject := reader loadProjectFrom: store / 'project'.
	newProject storageFile: aFile.
	newProject saveInImage.
	newProject open.
	self delete
]

{ #category : #'as yet unclassified' }
OPProjectBrowser >> projectMenu: aMenu [
	| project menuBuilder |
	project := recentList selectedItem ifNil: [ ^ self ].
	menuBuilder := OPMenuBuilder new menu: aMenu.
	menuBuilder
		addItem: 'Remove'
		action:
			[ project removeFromImage.
			recentList
				items: OPProjectStorage default projects;
				updateList ]
]

{ #category : #'as yet unclassified' }
OPProjectBrowser >> projectMenu: aMenu for: aProject [
	| menuBuilder |
	aProject ifNil: [ ^ self ].
	(menuBuilder := OPMenuBuilder new) menu: aMenu.
	menuBuilder
		addItem: 'Remove'
		action: [ aProject removeFromImage.
			self updateRecentList ]
]

{ #category : #'accessing - spec' }
OPProjectBrowser >> projectNameInput [
	^ projectNameInput
]

{ #category : #'accessing - spec' }
OPProjectBrowser >> quickStartLabel [
	^ quickStartLabel
]

{ #category : #'accessing - spec' }
OPProjectBrowser >> recentLabel [
	^ recentLabel
]

{ #category : #'accessing - spec' }
OPProjectBrowser >> recentList [
	^ recentList
]

{ #category : #initialization }
OPProjectBrowser >> setGroup [
	| group |
	group := RadioButtonGroup new.
	diagramOptions valuesDo: [ :each | group addRadioButton: each second ]
]

{ #category : #'accessing - spec' }
OPProjectBrowser >> title [
	^ 'OpenPonk Project Browser'
]

{ #category : #'as yet unclassified' }
OPProjectBrowser >> updateRecentList [
	^ recentList
		items: OPProjectStorage default projects;
		updateList
]
