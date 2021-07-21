"
I am the topmost window of an opened Project.
"
Class {
	#name : #OPWorkbench,
	#superclass : #ComposablePresenter,
	#instVars : [
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
		'projectTree'
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
	^ self layoutStyle ~= #separated
]

{ #category : #specs }
OPWorkbench class >> specCombined [
	<spec: #combined>
	^ SpecLayout composed
		newRow: [ :row | 
			row
				newColumn: [ :col | col add: #topToolbar height: self toolbarHeight ] ]
			height: self toolbarHeight;
		newRow: [ :row | 
			row
				newColumn: [ :col | 
					col
						add: #projectTree;
						add: #diagramWidget ]
					width: 250;
				addSplitter;
				newColumn: [ :col | col add: #tabManager ] ]
			top: self toolbarHeight;
		yourself
]

{ #category : #specs }
OPWorkbench class >> specSeparated [
	<spec: #separated>
	^ SpecLayout composed
		newRow: [ :row | 
			row
				newColumn: [ :col | col add: #topToolbar height: self toolbarHeight ] ]
			height: self toolbarHeight;
		newRow: [ :row | 
			row
				newColumn: [ :col | 
					col
						add: #projectTree;
						add: #diagramWidget ]
					width: 250;
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
OPWorkbench >> deleteDiagram: aDiagram [
	self closeEditorOfView: aDiagram.
	self projectController removeDiagram: aDiagram
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
				ifNotNil: [ :oldDiagram | 
					self projectController updateDiagram: oldDiagram.
					oldDiagram isSelected: false ].
			self announce: (OPEditorUnfocused on: focusedEditor) ].
	editorTabPair := editors at: aDiagram.
	focusedEditor := editorTabPair first.
	aDiagram isSelected: true.
	editorTabPair second selected: true.
	self announce: (OPEditorFocused on: focusedEditor).
	topToolbar activeEditor: focusedEditor.
	focusedEditor showDiagram: aDiagram
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
	self currentWorld extent x > 3000
		ifTrue: [ ^ 1200 @ 800 ].
	^ self currentWorld extent * (0.65 @ 0.7)
]

{ #category : #initialization }
OPWorkbench >> initialize [
	pluginRegistry := OPPluginRegistry default.
	editors := IdentityDictionary new.
	super initialize
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
	projectTree := self instantiate: OPProjectNavigator.
	tabManager := self newTabManager.
	formModel := self instantiate: OPScrollableForm.
	self focusOrder
		add: topToolbar;
		add: diagramWidget;
		add: projectTree;
		add: formModel;
		add: tabManager
]

{ #category : #opening }
OPWorkbench >> open [
	self openWithSpec: self class layoutStyle
]

{ #category : #opening }
OPWorkbench >> openEditorOn: aModel [
	self
		openEditorOnDiagram: (project diagrams detect: [ :each | each model = aModel ])
]

{ #category : #opening }
OPWorkbench >> openEditorOnDiagram: aDiagram [
	| editor tab plugin widget model |
	(self projectController hasDiagram: aDiagram)
		ifTrue: [ ^ self focusEditorOf: aDiagram ].
	model := aDiagram model.
	plugin := pluginRegistry pluginFor: model.
	editor := OPEditor on: plugin.
	editor workbench: self.
	tab := self newTab.
	editors at: aDiagram put: (Array with: editor with: tab).
	widget := editor buildWithSpec asWidget.
	editor owner: tab.
	editor openEmptyModel: model.
	(model respondsTo: #whenChanged:)
		ifTrue: [ model
				whenChanged: [ tab label: '[' , aDiagram name , '] ' , model name ] ].
	editor paletteModel rebuildWidget.
	tab
		label: '[' , aDiagram name , '] ' , model name;
		icon: plugin icon;
		retrievingBlock: [ widget ];
		whenBuiltDo: [ :w | 
			w widget when: #tabDeleted send: #tabDeleted to: editor.
			w widget
				when: #tabDeleted
				evaluate: [ :t | self closeEditor: editor ] ].
	self announce: (OPEditorCreated on: editor).
	tabManager addTab: tab.
	self focusEditorOf: aDiagram
]

{ #category : #opening }
OPWorkbench >> openFormOn: aController [
	self useEditorForm
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
	projectTree openOn: project.
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
OPWorkbench >> projectTree [
	^ projectTree
]

{ #category : #api }
OPWorkbench >> retrieveSpec: aSelector [
	((SpecPragmaCollector behavior: self class class)
		filter:
				[ :pragma | pragma selector = #spec: and: [ pragma arguments first = aSelector ] ];
		reset;
		collected)
		ifNotEmpty: [ :pragmas | ^ super retrieveSpec: pragmas first method selector ].
	^ super retrieveSpec: aSelector
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

{ #category : #opening }
OPWorkbench >> useEditorForm [
	^ useEditorForm
		ifNil: [ useEditorForm := self class shouldUseEditorForm ]
]

{ #category : #'accessing - spec' }
OPWorkbench >> workbench [
	^ self
]
