"
I am a window with listing of all existing DCProjects and a simple interface for manipulating them (creating, removing, opening, ...)

[[[
DCProjectBrowser open
]]]
"
Class {
	#name : #OPProjectBrowser,
	#superclass : #SpPresenter,
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

{ #category : #'System-FileRegistry' }
OPProjectBrowser class >> fileReaderServicesForFile: fullName suffix: suffix [

	"Answers a collection of services that can handle the file and suffixes"

	<fileService>
	suffix = 'opp' ifTrue: [ ^ { self serviceOpen } ].
	^ {  }
]

{ #category : #'world menu' }
OPProjectBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #OpenPonk)
		icon: OPCoreIcons openponkIcon;
		action: [ self open ];
		withSeparatorAfter;
		order: 200
]

{ #category : #'instance creation' }
OPProjectBrowser class >> open [
	<script>
	^ self new open
]

{ #category : #'System-FileRegistry' }
OPProjectBrowser class >> serviceOpen [

	"answers a service for opening the project window from project file"

	^ SimpleServiceEntry
		  provider: self new
		  label: 'Load'
		  selector: #openProjectFromFile:
		  description: 'Open OpenPonk project'
]

{ #category : #initialization }
OPProjectBrowser >> connectPresenters [

	super connectPresenters.
	recentList
		items: OPProjectStorage default projects;
		display: #name;
		whenActivatedDo: [ 
			self openProjectFromFile: recentList selectedItem storageFile ];
		contextMenu: [ 
			self projectMenu: self newMenu for: recentList selectedItem ].
	projectNameInput whenTextChangedDo: [ :newValue | 
		createProjectButton enabled: newValue isNotEmpty ].
	createProjectButton action: [ self createProject ].
	openProjectButton action: [ self openProjectFromFile ]
]

{ #category : #initialization }
OPProjectBrowser >> createProject [

	| project |
	project := OPProject named: projectNameInput text.
	diagramOptions associations
		detect: [ :eachAssoc | eachAssoc value state ]
		ifFound: [ :eachAssoc | 
			project addModel: (eachAssoc key newModel
					 name: projectNameInput text;
					 yourself) ].
	self openProject: project
]

{ #category : #'accessing - spec' }
OPProjectBrowser >> createProjectButton [
	^ createProjectButton
]

{ #category : #initialization }
OPProjectBrowser >> initialize [
	diagramOptions := Dictionary new.
	pluginRegistry := OPPluginRegistry default.
	super initialize
]

{ #category : #initialization }
OPProjectBrowser >> initializeLayout [

	| rightColumn |
	rightColumn := SpBoxLayout newTopToBottom.
	rightColumn
		add: self newNullPresenter height: 5;
		add: #quickStartLabel height: self class buttonHeight.
	diagramOptions do: [ :each | 
		rightColumn add: each height: self class buttonHeight ].
	rightColumn
		add: self newNullPresenter;
		add: #projectNameInput height: self class buttonHeight;
		add: self newNullPresenter height: 5;
		add: #createProjectButton height: self class buttonHeight.

	self layout: (SpPanedLayout newLeftToRight
			 add: (SpBoxLayout newTopToBottom
					  add: self newNullPresenter height: 5;
					  add: #recentLabel height: self class buttonHeight;
					  add: #recentList expand: true fill: true;
					  add: self newNullPresenter height: 5;
					  add: #openProjectButton height: self class buttonHeight);
			 add: rightColumn;
			 yourself)
]

{ #category : #initialization }
OPProjectBrowser >> initializePresenters [

	| radioButtons |
	recentLabel := self newLabel label: 'Recent Projects'.
	recentList := self newList.
	quickStartLabel := self newLabel label: 'Quick Start'.
	projectNameInput := self newTextInput text: 'New Project'.
	createProjectButton := self newButton label: 'Create Project'.
	openProjectButton := self newButton label: 'Open Project...'.
	
	pluginRegistry pluginsDo: [ :each | 
		diagramOptions at: each put: (self newRadioButton label: each name) ].

	self initializeLayout.
	
	radioButtons := diagramOptions asArray.
	radioButtons size < 2 ifTrue: [ ^ self ].
	radioButtons first associatedRadioButtons:
		radioButtons copyWithoutFirst
]

{ #category : #initialization }
OPProjectBrowser >> initializeWindow: aWindow [

	aWindow
		windowIcon: OPCoreIcons openponkIcon;
		title: 'OpenPonk Project Browser';
		initialExtent: 400 @ 400
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

{ #category : #initialization }
OPProjectBrowser >> openProjectFromDirectory [

	^ OPProjectController fromDirectoryDo: [ :aProject | 
		  self openProject: aProject ]
]

{ #category : #initialization }
OPProjectBrowser >> openProjectFromFile [

	^ OPProjectController fromFileDo: [ :aProject | 
		  self openProject: aProject ]
]

{ #category : #'project handling' }
OPProjectBrowser >> openProjectFromFile: aFile [

	^ self openProject: (OPProjectController fromFile: aFile)
]

{ #category : #initialization }
OPProjectBrowser >> projectMenu: aMenuPresenter [

	self
		projectMenu: aMenuPresenter
		for: (recentList selectedItem ifNil: [ ^ aMenuPresenter ])
]

{ #category : #initialization }
OPProjectBrowser >> projectMenu: aMenuPresenter for: aProject [

	aProject ifNil: [ ^ aMenuPresenter ].
	aMenuPresenter addItem: [ :item | 
		item
			name: 'Remove';
			action: [ 
				aProject removeFromImage.
				self updateRecentList ] ].
	^ aMenuPresenter
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
OPProjectBrowser >> updateRecentList [
	^ recentList
		items: OPProjectStorage default projects;
		updateList
]
