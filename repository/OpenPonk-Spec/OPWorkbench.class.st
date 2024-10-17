"
I am the topmost window of an opened Project.
"
Class {
	#name : 'OPWorkbench',
	#superclass : 'SpPresenter',
	#instVars : [
		'project',
		'projectController',
		'pluginRegistry',
		'topToolbar',
		'editors',
		'focusedEditor',
		'projectTree',
		'notebook',
		'diagramsList'
	],
	#classInstVars : [
		'isDevelopmentMode'
	],
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'specs' }
OPWorkbench class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newTopToBottom
				   add: #topToolbar;
				   yourself)
		  expand: false;
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

	^ self currentWorld extent * 0.8 min: 1600 @ 1000
]

{ #category : 'api' }
OPWorkbench class >> initialListsWidth [

	^ 250
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
	anEditor tabClosedWhileClosingWorkbench: discardChanges.
	topToolbar activeEditor: nil.
	editors removeKey: anEditor diagramController diagramElement.
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

{ #category : 'initialization' }
OPWorkbench >> initialize [
	pluginRegistry := OPPluginRegistry default.
	editors := IdentityDictionary new.
	super initialize
]

{ #category : 'initialization' }
OPWorkbench >> initializePresenters [

	topToolbar := self instantiate: OPWorkbenchToolbar.
	diagramsList := self instantiate: OPDiagramsList.
	projectTree := self instantiate: OPProjectNavigator.
	notebook := self newNotebook.
	self focusOrder
		add: topToolbar;
		add: diagramsList;
		add: projectTree;
		add: notebook
]

{ #category : 'initialization' }
OPWorkbench >> initializeWindow: aWindow [

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
		(project diagrams detect: [ :each | each modelElement = aModel ])
]

{ #category : 'opening' }
OPWorkbench >> openEditorOnDiagram: aDiagram [

	| editor notebookPage plugin model |
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
	(model respondsTo: #whenChanged:) ifTrue: [ 
		model whenChanged: [ 
			notebookPage title: '[' , aDiagram name , '] ' , model name ] ].
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

{ #category : 'project handling' }
OPWorkbench >> openProject: aProject [

	project := aProject.
	(projectController := aProject controllerClass new)
		project: project;
		workbench: self.
	topToolbar updateProjectMenu.
	project whenChanged: [ self updateTitle ].
	diagramsList project: project.
	projectTree openOn: project.
	projectController openDiagrams.
	self hasWindow ifFalse: [ self open ].
	self withWindowDo: [ :window | 
		window whenClosedDo: [ project unsubscribe: self ] ].
	self updateTitle.
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

{ #category : 'protocol' }
OPWorkbench >> title [
	^ project
		  ifNil: [ 'OpenPonk' ]
		  ifNotNil: [ 
			(project storageFile) ifNil: [ project name , ' - OpenPonk']
									 	ifNotNil: [ project storageFile path pathString, ' - ', project name, ' - OpenPonk' ] ]
]

{ #category : 'accessing - spec' }
OPWorkbench >> topToolbar [
	^ topToolbar
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
