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
	#category : 'OpenPonk-Spec-Windows'
}

{ #category : #settings }
OPWorkbench class >> availableLayoutStyles [
	^ ((SpecPragmaCollector behavior: self class)
		filter: [ :pragma | pragma keyword = #spec: ];
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
	editors removeKey: anEditor diagramController diagramView.
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
OPWorkbench >> focusEditorOf: aView [
	| editorTabPair |
	(focusedEditor isNotNil and: [ focusedEditor diagramController diagramView = aView ])
		ifTrue: [ ^ self ].
	focusedEditor
		ifNotNil: [ focusedEditor diagramController diagramView
				ifNotNil: [ :oldView | oldView isSelected: false ].
			self announce: (OPEditorUnfocused on: focusedEditor) ].
	editorTabPair := editors at: aView.
	focusedEditor := editorTabPair first.
	aView isSelected: true.
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
	diagramWidget := self instantiate: OPDiagramViewsWidget.
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
		openEditorOnView: (project views detect: [ :each | each model = aModel & each isDefault ])
]

{ #category : #opening }
OPWorkbench >> openEditorOnView: aView [
	^ self openEditorOnView: aView model: aView model
]

{ #category : #opening }
OPWorkbench >> openEditorOnView: aView model: aModel [
	| editor tab plugin widget |
	(self projectController hasView: aView)
		ifTrue: [ ^ self focusEditorOf: aView ].
	plugin := pluginRegistry pluginFor: aModel.
	editor := OPEditor on: plugin.
	editor workbench: self.
	tab := self newTab.
	editors at: aView put: (Array with: editor with: tab).
	widget := editor buildWithSpec asWidget.
	editor owner: tab.
	editor openEmptyModel: aModel.
	(aModel respondsTo: #whenChanged:)
		ifTrue: [ aModel whenChanged: [ tab label: '[' , aView name , '] ' , aModel name ] ].
	editor paletteModel rebuildWidget.
	tab
		label: '[' , aView name , '] ' , aModel name;
		icon: plugin icon;
		retrievingBlock: [ widget ];
		whenBuiltDo: [ :w | 
			w widget when: #tabDeleted send: #tabDeleted to: editor.
			w widget when: #tabDeleted evaluate: [ :t | self closeEditor: editor ] ].
	self announce: (OPEditorCreated on: editor).
	tabManager addTab: tab.
	self focusEditorOf: aView.
	editor applyView: aView
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
	projectController openViews
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
