"
I am the topmost window of an opened Project.
"
Class {
	#name : #OPWorkbench,
	#superclass : #ComposableModel,
	#traits : 'TOPSpecRetriever',
	#classTraits : 'TOPSpecRetriever classTrait',
	#instVars : [
		'navigatorModel',
		'modelTreeWidget',
		'tabManager',
		'formModel',
		'project',
		'projectController',
		'pluginRegistry',
		'topToolbar',
		'editors',
		'focusedEditor',
		'diagramWidget',
		'useEditorForm',
		'modelTree'
	],
	#classInstVars : [
		'layoutStyle',
		'isDevelopmentMode'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #settings }
OPWorkbench class >> availableLayoutStyles [
	^ ((SpecPragmaCollector behavior: self class)
		filter: [ :pragma | pragma selector = #spec: ];
		reset;
		collected) collect: [ :pragma | pragma arguments first ]
]

{ #category : #settings }
OPWorkbench class >> defaultLayoutStyle [
	^ #separated
]

{ #category : #settings }
OPWorkbench class >> developerSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #'op-dev') label: 'OpenPonk Development'; parent: #openponk.
	(aBuilder setting: #isDevelopmentMode)
		parent: #'op-dev';
		target: self;
		label: 'Enable Development Mode';
		description: 'Add extra options useful for developers.';
		default: false
]

{ #category : #settings }
OPWorkbench class >> isDevelopmentMode [
	^ isDevelopmentMode ifNil: [ false ]
]

{ #category : #settings }
OPWorkbench class >> isDevelopmentMode: aBoolean [
	isDevelopmentMode := aBoolean
]

{ #category : #settings }
OPWorkbench class >> layoutStyle [
	^ layoutStyle ifNil: [ layoutStyle := self defaultLayoutStyle ]
]

{ #category : #settings }
OPWorkbench class >> layoutStyle: aStyle [
	layoutStyle := aStyle
]

{ #category : #'instance creation' }
OPWorkbench class >> open [
	^ self new open
]

{ #category : #'instance creation' }
OPWorkbench class >> openModel: aModel [
	| project |
	project := OPProject new.
	project name: 'Click Project'.
	project addModel: aModel.
	^ self open
		openProject: project;
		yourself
]

{ #category : #'instance creation' }
OPWorkbench class >> openProject: aProject [
	^ self open
		openProject: aProject;
		yourself
]

{ #category : #settings }
OPWorkbench class >> settingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #openponk) label: 'OpenPonk'.
	(aBuilder pickOne: #layoutStyle)
		parent: #openponk;
		target: self;
		label: 'Form Layout Style';
		description: 'Separate or combine Palette and Form widgets.';
		default: self defaultLayoutStyle;
		domainValues: self availableLayoutStyles
]

{ #category : #specs }
OPWorkbench class >> shouldUseEditorForm [
	^ (self layoutStyle = #separated) not
]

{ #category : #specs }
OPWorkbench class >> specCombined [
	<spec: #combined>
	^ SpecLayout composed
		newRow: [ :row | row newColumn: [ :col | col add: #topToolbar height: self toolbarHeight ] ]
			height: self toolbarHeight;
		newRow: [ :row | 
			row
				newColumn: [ :col | 
					col
						add: #diagramWidget height: 200;
						add: #modelTree ]
					width: 200;
				addSplitter;
				newColumn: [ :col | col add: #tabManager ] ]
			top: self toolbarHeight;
		yourself
]

{ #category : #specs }
OPWorkbench class >> specSeparated [
	<spec: #separated>
	^ SpecLayout composed
		newRow: [ :row | row newColumn: [ :col | col add: #topToolbar height: self toolbarHeight ] ]
			height: self toolbarHeight;
		newRow: [ :row | 
			row
				newColumn: [ :col | 
					col
						add: #diagramWidget;
						add: #navigatorModel ]
					width: 200;
				addSplitter;
				newColumn: [ :col | col add: #tabManager ];
				addSplitter;
				newColumn: [ :col | col add: #formModel ] width: 150 ]
			top: self toolbarHeight;
		yourself
]

{ #category : #opening }
OPWorkbench >> closeEditor: anEditor [
	topToolbar activeEditor: nil.
	editors removeKey: anEditor diagramController diagram.
	focusedEditor = anEditor
		ifTrue: [ focusedEditor := nil.
			self announce: (OPEditorUnfocused on: anEditor) ].
	self announce: (OPEditorClosed on: anEditor)
]

{ #category : #opening }
OPWorkbench >> closeEditorOf: aView [
	editors
		at: aView
		ifPresent: [ :pair | 
			tabManager removeTab: pair second.
			self announce: (OPEditorClosed on: pair first) ]
]

{ #category : #opening }
OPWorkbench >> closeEditorOfView: aView [
	editors
		at: aView
		ifPresent: [ :pair | 
			tabManager removeTab: pair second.
			self announce: (OPEditorClosed on: pair first) ]
]

{ #category : #'accessing - spec' }
OPWorkbench >> diagramWidget [
	^ diagramWidget
]

{ #category : #opening }
OPWorkbench >> focusEditorOf: aDiagram [
	| editorTabPair |
	(focusedEditor isNotNil
		and: [ focusedEditor diagramController diagram = aDiagram ])
		ifTrue: [ ^ self ].
	focusedEditor
		ifNotNil: [ focusedEditor diagramController diagram
				ifNotNil: [ :oldDiagram | oldDiagram isSelected: false ].
			self announce: (OPEditorUnfocused on: focusedEditor) ].
	editorTabPair := editors at: aDiagram.
	focusedEditor := editorTabPair first.
	aDiagram isSelected: true.
	editorTabPair second selected: true.
	self announce: (OPEditorFocused on: focusedEditor).
	topToolbar activeEditor: focusedEditor
]

{ #category : #accessing }
OPWorkbench >> focusedEditor [
	^ focusedEditor
]

{ #category : #'accessing - spec' }
OPWorkbench >> formModel [
	^ formModel
]

{ #category : #protocol }
OPWorkbench >> initialExtent [
	World extent x > 3000
		ifTrue: [ ^ 1200 @ 800 ].
	^ World extent * (0.65 @ 0.7)
]

{ #category : #initialization }
OPWorkbench >> initialize [
	pluginRegistry := OPPluginRegistry default.
	editors := IdentityDictionary new.
	super initialize
]

{ #category : #initialization }
OPWorkbench >> initializeModelTree [
	| modelTreeTab projectTreeTab |
	(modelTreeTab := self newTab)
		label: 'Model Tree';
		icon: nil;
		retrievingBlock: [ (modelTreeWidget buildWithSpec: #withoutHeadingSpec) asWidget ].
	(projectTreeTab := self newTab)
		label: 'Project Tree';
		icon: nil;
		retrievingBlock: [ (navigatorModel buildWithSpec: #withoutHeadingSpec) asWidget ].
	modelTree
		addTab: modelTreeTab;
		addTab: projectTreeTab
]

{ #category : #initialization }
OPWorkbench >> initializePresenter [
	super initializePresenter.
	tabManager
		whenTabSelected:
			[ :tab | self focusEditorOf: (editors associations detect: [ :pair | pair value second = tab ]) key ]
]

{ #category : #initialization }
OPWorkbench >> initializeWidgets [
	topToolbar := self instantiate: OPWorkbenchToolbar.
	diagramWidget := self instantiate: OPDiagramsWidget.
	modelTree := self newTabManager.
	self initializeModelTree.
	modelTreeWidget := self instantiate: OPModelNavigator.
	navigatorModel := self instantiate: OPProjectNavigator.
	tabManager := self newTabManager.
	formModel := self instantiate: OPScrollableForm.
	self focusOrder
		add: topToolbar;
		add: diagramWidget;
		add: navigatorModel;
		add: formModel;
		add: tabManager
]

{ #category : #'accessing - spec' }
OPWorkbench >> modelTree [
	^ modelTree
]

{ #category : #'accessing - spec' }
OPWorkbench >> modelTreeWidget [
	^ modelTreeWidget
]

{ #category : #'accessing - spec' }
OPWorkbench >> navigatorModel [
	^ navigatorModel
]

{ #category : #opening }
OPWorkbench >> open [
	useEditorForm := self class shouldUseEditorForm.
	self openWithSpec: self class layoutStyle
]

{ #category : #opening }
OPWorkbench >> openEditorOn: aModel [
	self
		openEditorOnDiagram: (project diagrams detect: [ :each | each model = aModel & each isDefault ])
]

{ #category : #opening }
OPWorkbench >> openEditorOnDiagram: aDiagram [
	^ self openEditorOnDiagram: aDiagram model: aDiagram model
]

{ #category : #opening }
OPWorkbench >> openEditorOnDiagram: aDiagram model: aModel [
	| editor tab plugin widget |
	(self projectController hasDiagram: aDiagram)
		ifTrue: [ ^ self focusEditorOf: aDiagram ].
	plugin := pluginRegistry pluginFor: aModel.
	editor := OPEditor on: plugin.
	editor workbench: self.
	tab := self newTab.
	editors at: aDiagram put: (Array with: editor with: tab).
	widget := editor buildWithSpec asWidget.
	editor owner: tab.
	editor openEmptyModel: aModel.
	(aModel respondsTo: #whenChanged:)
		ifTrue: [ aModel
				whenChanged: [ tab label: '[' , aDiagram name , '] ' , aModel name ] ].
	editor paletteModel rebuildWidget.
	tab
		label: '[' , aDiagram name , '] ' , aModel name;
		icon: plugin icon;
		retrievingBlock: [ widget ];
		whenBuiltDo: [ :w | 
			w widget when: #tabDeleted send: #tabDeleted to: editor.
			w widget
				when: #tabDeleted
				evaluate: [ :t | self closeEditor: editor ] ].
	self announce: (OPEditorCreated on: editor).
	tabManager addTab: tab.
	self focusEditorOf: aDiagram.
	editor applyView: aDiagram
]

{ #category : #opening }
OPWorkbench >> openFormOn: aController [
	useEditorForm
		ifTrue: [ focusedEditor openFormOn: aController ]
		ifFalse: [ formModel editController: aController ]
]

{ #category : #'project handling' }
OPWorkbench >> openProject: aProject [
	project := aProject.
	(projectController := aProject controllerClass new)
		project: project;
		workbench: self.
	self updateTitle.
	topToolbar updateProjectMenu.
	project whenChanged: [ self updateTitle ].
	diagramWidget project: project.
	navigatorModel openOn: project.
	modelTreeWidget openOn: project.
	projectController openDiagrams
]

{ #category : #accessing }
OPWorkbench >> pluginRegistry [
	^ pluginRegistry
]

{ #category : #accessing }
OPWorkbench >> projectController [
	^ projectController
]

{ #category : #'accessing - spec' }
OPWorkbench >> tabManager [
	^ tabManager
]

{ #category : #protocol }
OPWorkbench >> title [
	^ project ifNil: [ 'OpenPonk' ] ifNotNil: [ project name , ' - ' , 'OpenPonk' ]
]

{ #category : #'accessing - spec' }
OPWorkbench >> topToolbar [
	^ topToolbar
]

{ #category : #'accessing - spec' }
OPWorkbench >> workbench [
	^ self
]
