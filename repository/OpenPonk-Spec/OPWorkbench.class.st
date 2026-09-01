"
Core Spec presenter serving as the main workbench window for an opened OpenPonk project. 
Orchestrates the layout containing the project tree, dynamic property forms, the diagram editor notebook, and the top toolbar.
"
Class {
	#name : 'OPWorkbench',
	#superclass : 'SpPresenter',
	#instVars : [
		'pluginRegistry',
		'projectController',
		'diagramsList',
		'projectTree',
		'editors',
		'focusedEditor',
		'notebook',
		'form',
		'topToolbar'
	],
	#classInstVars : [
		'isDevelopmentMode'
	],
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'layout' }
OPWorkbench class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newTopToBottom
				   add: #topToolbar;
				   yourself)
		  expand: false;
		  add: (SpPanedLayout newLeftToRight
				   add: (SpPanedLayout newLeftToRight
						    add: (SpPanedLayout newTopToBottom
								     add: #projectTree;
								     add: #diagramsList;
								     yourself);
						    positionOfSlider: self initialListsWidth;
						    add: (SpBoxLayout newTopToBottom
								     add: #notebook;
								     yourself);
						    yourself);
				   positionOfSlider: self initialWidth - self initialFormWidth;
				   add: (SpTabLayout new
						    add: (SpScrollableLayout with: #form) label: 'Properties';
						    yourself);
				   yourself);
		  yourself
]

{ #category : 'settings' }
OPWorkbench class >> developerSettingsOn: aBuilder [

	<systemsettings>
	(aBuilder group: #'op-dev')
		label: 'OpenPonk Development';
		parent: #openponk;
		order: 100.
	(aBuilder setting: #isDevelopmentMode)
		parent: #'op-dev';
		target: self;
		label: 'Enable Development Mode';
		description: 'Add extra options useful for developers.'
]

{ #category : 'api' }
OPWorkbench class >> initialExtent [

	^ self currentWorld extent * 0.9 min: 1800 @ 1000
]

{ #category : 'api' }
OPWorkbench class >> initialFormWidth [

	^ self initialSidePaneWidth
]

{ #category : 'api' }
OPWorkbench class >> initialListsWidth [

	^ self initialSidePaneWidth
]

{ #category : 'api' }
OPWorkbench class >> initialSidePaneWidth [

	^ 250
]

{ #category : 'api' }
OPWorkbench class >> initialWidth [

	^ self initialExtent x
]

{ #category : 'settings' }
OPWorkbench class >> isDevelopmentMode [
	^ isDevelopmentMode ifNil: [ false ]
]

{ #category : 'settings' }
OPWorkbench class >> isDevelopmentMode: aBoolean [
	isDevelopmentMode := aBoolean
]

{ #category : 'instance creation' }
OPWorkbench class >> open [

	^ (self newApplication: OPApplication new) open
]

{ #category : 'instance creation' }
OPWorkbench class >> openModel: aModel [

	| project |
	project := OPProject new.
	project name: 'New Project'.
	project addModel: aModel.
	^ self
		  openProject: project;
		  yourself
]

{ #category : 'instance creation' }
OPWorkbench class >> openProject: aProject [

	^ (self newApplication: OPApplication new)
		  openProject: aProject;
		  yourself
]

{ #category : 'settings' }
OPWorkbench class >> settingsOn: aBuilder [

	<systemsettings>
	(aBuilder group: #openponk) label: 'OpenPonk'
]

{ #category : 'initialize-release' }
OPWorkbench >> close [

	self withWindowDo: [ :window | window close ]
]

{ #category : 'opening' }
OPWorkbench >> closeEditorOfDiagram: aDiagram [

	editors
		at: aDiagram
		ifPresent: [ :editorInfo | 
		notebook removePage: (editorInfo at: #page) ]
]

{ #category : 'opening' }
OPWorkbench >> closedTabOfEditor: anEditor [

	self closedTabOfEditor: anEditor whileClosingWorkbench: false
]

{ #category : 'opening' }
OPWorkbench >> closedTabOfEditor: anEditor whileClosingWorkbench: discardChanges [

	focusedEditor = anEditor ifTrue: [
		focusedEditor := nil.
		self announce: (OPEditorUnfocused on: anEditor) ].
	topToolbar activeEditor: nil.
	editors removeKey: anEditor diagramController diagramElement.
	anEditor tabClosedWhileClosingWorkbench: discardChanges.
	self announce: (OPEditorClosed on: anEditor)
]

{ #category : 'initialization' }
OPWorkbench >> connectPresenters [

	super connectPresenters.
	notebook
		whenSelectedPageChangedDo: [ :newPage | 
			self focusEditorOf: (editors associations detect: [ :pair | 
							 (pair value at: #page) = newPage ]) key ];
		whenPageRemovedDo: [ :page | self pageRemoved: page ]
]

{ #category : 'accessing - spec' }
OPWorkbench >> deleteDiagram: aDiagram [
	self closeEditorOfDiagram: aDiagram.
	self projectController removeDiagram: aDiagram
]

{ #category : 'accessing - spec' }
OPWorkbench >> diagramsList [
	^ diagramsList
]

{ #category : 'opening' }
OPWorkbench >> focusEditorOf: aDiagram [

	| editorTabInfo |
	(focusedEditor isNotNil and: [ 
		 focusedEditor diagramController diagramElement = aDiagram ]) 
		ifTrue: [ ^ self ].
	editorTabInfo := editors at: aDiagram.
	notebook selectedPage = (editorTabInfo at: #page) ifFalse: [ 
		^ notebook selectPage: (editorTabInfo at: #page) ].

	focusedEditor ifNotNil: [ 
		focusedEditor diagramController diagramElement ifNotNil: [ 
			:oldDiagram | 
			self projectController updateDiagram: oldDiagram.
			oldDiagram isSelected: false ].
		self announce: (OPEditorUnfocused on: focusedEditor) ].
	focusedEditor := editorTabInfo at: #editor.
	aDiagram isSelected: true.
	self announce: (OPEditorFocused on: focusedEditor).
	topToolbar activeEditor: focusedEditor.
	focusedEditor diagramController diagramElement: aDiagram.
	focusedEditor diagramController diagramFocused
]

{ #category : 'accessing' }
OPWorkbench >> focusedEditor [
	^ focusedEditor
]

{ #category : 'accessing - spec' }
OPWorkbench >> form [
	^ form
]

{ #category : 'initialization' }
OPWorkbench >> initialize [

	pluginRegistry := OPPluginRegistry default.
	editors := IdentityDictionary new.
	super initialize
]

{ #category : 'initialization' }
OPWorkbench >> initializePresenters [

	topToolbar := self instantiate: OPWorkbenchToolbar.
	projectTree := self instantiate: OPProjectTree.
	diagramsList := self instantiate: OPDiagramsList.
	notebook := self newNotebook.
	form := self instantiate: OPDynamicForm.
	self focusOrder
		add: topToolbar;
		add: projectTree;
		add: diagramsList;
		add: notebook;
		add: form
]

{ #category : 'initialization' }
OPWorkbench >> initializeWindow: aWindow [

	super initializeWindow: aWindow.

	aWindow
		windowIcon: OPCoreIcons openponkIcon;
		title: self title;
		initialExtent: self class initialExtent;
		whenClosedDo: [
			editors valuesDo: [ :each |
					self
						closedTabOfEditor: (each at: #editor)
						whileClosingWorkbench: true ] ]
]

{ #category : 'accessing - spec' }
OPWorkbench >> notebook [
	^ notebook
]

{ #category : 'opening' }
OPWorkbench >> openEditorOn: aModel [

	self openEditorOnDiagram:
		(self project diagrams detect: [ :each | each modelElement = aModel ])
]

{ #category : 'opening' }
OPWorkbench >> openEditorOnDiagram: aDiagram [
    "Opens an editor for the diagram and subscribes to the respective view model."
    | editor notebookPage plugin model viewModel |
    (self projectController hasDiagram: aDiagram) ifTrue: [
        ^ self focusEditorOf: aDiagram ].
    model := aDiagram modelElement.
    plugin := pluginRegistry pluginFor: model.
    editor := OPEditor on: plugin.
    editor workbench: self.
    notebookPage := self newNotebookPage.
    notebookPage beCloseable.
    editors at: aDiagram put: {
            (#editor -> editor).
            (#page -> notebookPage) } asDictionary.
    editor owner: notebook.
    editor openEmptyModel: model.
    
    viewModel := self projectController viewModel registry viewModelFor: model.
    self whenWindowClosedUnsubscribeFrom: viewModel.
    viewModel announcer when: OPModelChanged send: #updateTabTitle to: self.
    
    editor palette rebuildWidget.
    notebookPage
        title: '[' , aDiagram name , '] ' , model name;
        icon: plugin icon;
        presenterProvider: [ editor ].
    self announce: (OPEditorCreated on: editor).
    notebook addPage: notebookPage.
    self focusEditorOf: aDiagram.
    ^ editor
]

{ #category : 'initialization' }
OPWorkbench >> openFormOn: aController [

	form target: aController
]

{ #category : 'project handling' }
OPWorkbench >> openProject: aProject [
    "Registers the project and subscribes to its view model events."
    | pViewModel |
    (projectController := aProject controllerClass new)
        project: aProject;
        workbench: self.
    topToolbar updateProjectMenu.
    
    pViewModel := projectController viewModel.
    self whenWindowClosedUnsubscribeFrom: pViewModel.
    pViewModel announcer when: OPModelChanged send: #updateTitle to: self.
    
    diagramsList project: aProject.
    projectTree openOn: pViewModel.
    projectController openDiagrams.
    self hasWindow ifFalse: [ self open ].
    self updateTitle
]

{ #category : 'opening' }
OPWorkbench >> pageRemoved: aPage [

	"activePresenter is editor"

	self closedTabOfEditor: aPage activePresenter
]

{ #category : 'accessing' }
OPWorkbench >> pluginRegistry [
	^ pluginRegistry
]

{ #category : 'accessing' }
OPWorkbench >> project [

	^ projectController project
]

{ #category : 'accessing' }
OPWorkbench >> projectController [
	^ projectController
]

{ #category : 'accessing - spec' }
OPWorkbench >> projectTree [
	^ projectTree
]

{ #category : 'opening' }
OPWorkbench >> showAllElementsInAllDiagrams [

	self projectController controllers do: [ :each | 
		each
			showAllElements;
			applyDefaultLayout.
		each canvas extent max <= 500 ifTrue: [ 
			each canvasPresenter whenExtentChangedDo: [ :evt | 
				each zoomToFit.
				each canvasPresenter whenExtentChangedDo: [ :event |  ] ] ] ].
	self projectController controllers do: #zoomToFit
]

{ #category : 'accessing - deprecated' }
OPWorkbench >> title [

	self projectController ifNil: [ ^ 'OpenPonk' ].

	self project storageFile ifNil: [
		^ self project name , ' - OpenPonk' ].

	^ self project storageFile path pathString , ' - '
	  , self project name , ' - OpenPonk'
]

{ #category : 'accessing - spec' }
OPWorkbench >> topToolbar [
	^ topToolbar
]

{ #category : 'protocol' }
OPWorkbench >> updateTabTitle [

	| page diagramController |
	page := notebook selectedPage ifNil: [ ^ self ].
	diagramController := page activePresenter diagramController.
	page title: '[' , diagramController diagramElement name , '] '
		, diagramController model name
]

{ #category : 'protocol' }
OPWorkbench >> updateTitle [

	^ self withWindowDo: [ :window | window title: self title ]
]

{ #category : 'protocol' }
OPWorkbench >> when: anEvent do: aBlock for: aSubscriber [

	^ self announcer when: anEvent do: aBlock for: aSubscriber
]

{ #category : 'accessing - spec' }
OPWorkbench >> workbench [
	^ self
]
