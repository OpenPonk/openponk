"
Spec presenter that provides the initial welcome screen and project browser for OpenPonk. 
Displays a list of recently opened projects and provides an interface for creating, opening, and importing project files.
"
Class {
	#name : 'OPProjectBrowser',
	#superclass : 'SpPresenter',
	#instVars : [
		'recentLabel',
		'recentList',
		'quickStartLabel',
		'projectNameInput',
		'pluginRegistry',
		'pluginsList',
		'templatesList',
		'createProjectButton',
		'openProjectButton'
	],
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'System-FileRegistry' }
OPProjectBrowser class >> fileReaderServicesForFile: fullName suffix: suffix [

	"Answers a collection of services that can handle the file and suffixes"

	<fileService>
	suffix = 'opp' ifTrue: [ ^ { self serviceOpen } ].
	^ {  }
]

{ #category : 'world menu' }
OPProjectBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #OpenPonk)
		icon: OPCoreIcons openponkIcon;
		label: 'OpenPonk';
		order: 200;
		action: [ self open ]
]

{ #category : 'instance creation' }
OPProjectBrowser class >> open [

	<script>
	^ (self newApplication: OPApplication new) open
]

{ #category : 'System-FileRegistry' }
OPProjectBrowser class >> serviceOpen [

	"answers a service for opening the project window from project file"

	^ SimpleServiceEntry
		  provider: self new
		  label: 'Open in OpenPonk'
		  selector: #openProjectFromFile:
		  description: 'Open OpenPonk project'
]

{ #category : 'initialization' }
OPProjectBrowser >> connectPresenters [
	super connectPresenters.
	recentList
		items: OPProjectStorage default projects;
		display: [ :project | project name ];
		whenActivatedDo: [ 
			self openProjectFromFile: recentList selectedItem storageFile ];
		contextMenu: [ 
			self projectMenu: self newMenu for: recentList selectedItem ].
	projectNameInput whenTextChangedDo: [ :newValue | 
		createProjectButton enabled: newValue isNotEmpty ].
	createProjectButton action: [ self createProject ].
	openProjectButton action: [ self openProjectFromFile ].

	pluginsList
		items: pluginRegistry plugins asOrderedCollection;
		display: [ :plugin | plugin name ];
		displayIcon: [ :plugin | plugin icon ];
		whenSelectedItemChangedDo: [ :selectedPlugin | 
			self updateTemplatesListFor: selectedPlugin ].

	templatesList
		display: [ :template | template name ];
		displayIcon: [ :template | template icon ];
		whenSelectedItemChangedDo: [ :selectedTemplate | 
			self templateSelected: selectedTemplate ];
		whenActivatedDo: [ self createProject ].

	pluginsList selectIndex: 1
]

{ #category : 'project handling' }
OPProjectBrowser >> createProject [
	| selectedTemplate model project workbench |
	selectedTemplate := templatesList selectedItem.
	selectedTemplate ifNil: [ ^ self ].
	model := selectedTemplate createModel.
	(model respondsTo: #name:) ifTrue: [ 
		(selectedTemplate isExample not or: [ model name isNil ]) ifTrue: [ 
			model name: projectNameInput text ] ].
	project := OPProject named: projectNameInput text.
	project addModel: model.
	workbench := self openProject: project.
	selectedTemplate isExample ifTrue: [ 
		(workbench respondsTo: #showAllElementsInAllDiagrams) ifTrue: [ 
			workbench showAllElementsInAllDiagrams ] ]
]

{ #category : 'accessing - spec' }
OPProjectBrowser >> createProjectButton [
	^ createProjectButton
]

{ #category : 'initialization' }
OPProjectBrowser >> initialize [
	pluginRegistry ifNil: [ pluginRegistry := OPPluginRegistry default ].
	super initialize
]

{ #category : 'initialization' }
OPProjectBrowser >> initializeLayout [
	| leftColumn listsLayout rightColumn |
	leftColumn := SpBoxLayout newTopToBottom
		spacing: 5;
		add: #recentLabel height: self class labelHeight;
		add: #recentList expand: true fill: true;
		add: #openProjectButton height: self class buttonHeight;
		yourself.

	listsLayout := SpPanedLayout newLeftToRight
		positionOfSlider: 0.45;
		add: #pluginsList;
		add: #templatesList;
		yourself.

	rightColumn := SpBoxLayout newTopToBottom
		spacing: 5;
		add: #quickStartLabel height: self class labelHeight;
		add: listsLayout expand: true fill: true;
		add: #projectNameInput height: self class buttonHeight;
		add: #createProjectButton height: self class buttonHeight;
		yourself.

	self layout: (SpPanedLayout newLeftToRight
		positionOfSlider: 0.45;
		add: leftColumn;
		add: rightColumn;
		yourself)
]

{ #category : 'initialization' }
OPProjectBrowser >> initializePresenters [
	recentLabel := self newLabel label: 'Recent Projects'.
	recentList := self newList.
	quickStartLabel := self newLabel label: 'Quick Start'.
	pluginsList := self newList.
	templatesList := self newList.
	projectNameInput := self newTextInput text: 'New Project'.
	createProjectButton := self newButton label: 'Create Project'.
	openProjectButton := self newButton label: 'Open Project...'.
	self initializeLayout
]

{ #category : 'initialization' }
OPProjectBrowser >> initializeWindow: aWindow [
	super initializeWindow: aWindow.
	aWindow
		windowIcon: OPCoreIcons openponkIcon;
		title: 'OpenPonk Project Browser';
		initialExtent: 800 @ 350
]

{ #category : 'project handling' }
OPProjectBrowser >> openProject: project [
	| workbench |
	project saveInImage.
	workbench := project open.
	self withWindowDo: [ :activeWindow | activeWindow close ].
	^ workbench
]

{ #category : 'accessing - spec' }
OPProjectBrowser >> openProjectButton [
	^ openProjectButton
]

{ #category : 'initialization' }
OPProjectBrowser >> openProjectFromDirectory [

	^ OPProjectController fromDirectoryDo: [ :aProject | 
		  self openProject: aProject ]
]

{ #category : 'initialization' }
OPProjectBrowser >> openProjectFromFile [

	^ OPProjectController fromFileDo: [ :aProject | 
		  self openProject: aProject ]
]

{ #category : 'project handling' }
OPProjectBrowser >> openProjectFromFile: aFile [

	^ self openProject: (OPProjectController fromFile: aFile)
]

{ #category : 'accessing' }
OPProjectBrowser >> pluginRegistry [
	^ pluginRegistry
]

{ #category : 'accessing - spec' }
OPProjectBrowser >> pluginsList [
	"Answers the list presenter holding registered notation plugins."

	^ pluginsList
]

{ #category : 'initialization' }
OPProjectBrowser >> projectMenu: aMenuPresenter [

	self
		projectMenu: aMenuPresenter
		for: (recentList selectedItem ifNil: [ ^ aMenuPresenter ])
]

{ #category : 'initialization' }
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

{ #category : 'accessing - spec' }
OPProjectBrowser >> projectNameInput [
	^ projectNameInput
]

{ #category : 'accessing - spec' }
OPProjectBrowser >> quickStartLabel [
	^ quickStartLabel
]

{ #category : 'accessing - spec' }
OPProjectBrowser >> recentLabel [
	^ recentLabel
]

{ #category : 'accessing - spec' }
OPProjectBrowser >> recentList [
	^ recentList
]

{ #category : 'accessing - model' }
OPProjectBrowser >> setModelBeforeInitialization: aPluginRegistry [
	super setModelBeforeInitialization: aPluginRegistry.
	pluginRegistry := aPluginRegistry
]

{ #category : 'updating' }
OPProjectBrowser >> templateSelected: aTemplate [
	aTemplate ifNil: [ ^ self ].
	projectNameInput text: aTemplate name
]

{ #category : 'accessing - spec' }
OPProjectBrowser >> templatesList [
	"Answers the list presenter holding project templates of the selected plugin."

	^ templatesList
]

{ #category : 'initialization' }
OPProjectBrowser >> updateRecentList [
	^ recentList
		items: OPProjectStorage default projects;
		updateList
]

{ #category : 'updating' }
OPProjectBrowser >> updateTemplatesListFor: aPlugin [
	| templates |
	aPlugin ifNil: [ 
		templatesList items: #(  ).
		^ self ].
	templates := aPlugin projectTemplates.
	templatesList items: templates asOrderedCollection.
	templates ifNotEmpty: [ 
		templatesList selectIndex: 1 ]
]
