"
I am a component for visualization and manipulation of diagrams.
I consist of canvas (Roassal's RTView) and a palette which depends on the type of diagram.
I am bound with a diagram package and cannot live without it.
"
Class {
	#name : #OPEditor,
	#superclass : #ComposablePresenter,
	#traits : 'TOPSpecRetriever',
	#classTraits : 'TOPSpecRetriever classTrait',
	#instVars : [
		'canvasModel',
		'paletteModel',
		'workbench',
		'canvasMenuModel',
		'formModel',
		'zoomLabel',
		'diagramController',
		'plugin',
		'shortcuts'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #toolbar }
OPEditor class >> developerToolbarMenu: aBuilder [
	<opEditorToolbarMenu>
	| editor |
	OPWorkbench isDevelopmentMode
		ifFalse: [ ^ self ].
	editor := aBuilder model.
	(aBuilder item: 'Inspect Controller...') action: [ editor diagramController inspect ].
	(aBuilder item: 'Export as PNG...') action: [ editor canvasModel exportAsPng ].
	aBuilder withSeparatorAfter
]

{ #category : #specs }
OPEditor class >> specCombined [
	<spec: #combined>
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				newColumn: [ :col | 
					col
						add: #canvasModel;
						addSplitter;
						newRow: [ :r | 
							r
								add: #canvasMenuModel;
								add: #zoomLabel width: 35 ]
							height: self toolbarHeight - 1 ];
				addSplitter;
				newColumn: [ :col | 
					col
						add: #paletteModel height: 220;
						add: #formModel ]
					width: 170 ];
		yourself
]

{ #category : #specs }
OPEditor class >> specSeparated [
	<spec: #separated>
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				newColumn: [ :col | 
					col
						add: #canvasModel;
						addSplitter;
						newRow: [ :r | 
							r
								add: #canvasMenuModel;
								add: #zoomLabel width: 35 ]
							height: self toolbarHeight - 1 ];
				addSplitter;
				newColumn: [ :col | 
					col
						add: #paletteModel
"						addSplitter;"
"						add: #formModel" ]
					width: 150 ];
		yourself
]

{ #category : #'diagram handling' }
OPEditor >> applyView: aDiagram [
	diagramController diagram: aDiagram.
	diagramController rebuild
]

{ #category : #api }
OPEditor >> buildWithSpec [
	^ self buildWithSpec: OPWorkbench layoutStyle
]

{ #category : #'accessing - spec' }
OPEditor >> canvasMenuModel [
	^ canvasMenuModel
]

{ #category : #'accessing - spec' }
OPEditor >> canvasModel [
	^ canvasModel
]

{ #category : #shortcuts }
OPEditor >> collectShortcuts [
	^ ((PragmaCollector
		filter: [ :prg | 
	prg selector = #opEditorShortcut:
		and: [ prg arguments first = self plugin class name ] ])
		reset;
		collect:
				[ :prg | prg methodClass theNonMetaClass perform: prg methodSelector with: self ])
		flattened
]

{ #category : #'private-focus' }
OPEditor >> createCommandContext [
	"Subclases should override it if they provide any selection"

	^ canvasModel createCommandContext
]

{ #category : #accessing }
OPEditor >> diagramController [
	^ diagramController
]

{ #category : #'private-focus' }
OPEditor >> enableCommanderShortcutsIn: aWidget [

	^ CmdKMDispatcher attachedTo: aWidget withCommandsFrom: self
]

{ #category : #'private-focus' }
OPEditor >> ensureKeyBindingsFor: aWidget [
	super ensureKeyBindingsFor: aWidget.
	^self enableCommanderShortcutsIn: aWidget
]

{ #category : #'accessing - spec' }
OPEditor >> formModel [
	^ formModel
]

{ #category : #initialization }
OPEditor >> initializePresenter [
	| menu |
	menu := OPDiagramToolbarActivation
		buildMenuInContext: (CmdSimpleToolContext for: canvasModel).
	menu buildSpecMenuOn: canvasMenuModel
]

{ #category : #initialization }
OPEditor >> initializeWidgets [
	canvasMenuModel := self instantiate: MenuModel.
	canvasModel := self instantiate: OPCanvasPresenter.
	paletteModel := self instantiate: OPScrollablePalette.
	formModel := self instantiate: OPScrollableForm.
	(zoomLabel := self newLabel) label: '100%'.
	self focusOrder
		add: canvasMenuModel;
		add: canvasModel;
		add: paletteModel;
		add: formModel
]

{ #category : #'diagram handling' }
OPEditor >> newDiagramControllerFor: aModel [
	^ plugin diagramControllerClass new
		model: aModel;
		editor: self;
		workbenchAnnouncer: self workbench announcer;
		yourself
]

{ #category : #'diagram handling' }
OPEditor >> openEmptyModel: aModel [
	diagramController := self newDiagramControllerFor: aModel.
	self workbench projectController addDiagramController: diagramController.
	canvasModel attachController: diagramController.
	self rebuildWidget
]

{ #category : #'as yet unclassified' }
OPEditor >> openFormOn: aController [
	formModel editController: aController
]

{ #category : #'accessing - spec' }
OPEditor >> paletteModel [
	^ paletteModel
]

{ #category : #accessing }
OPEditor >> plugin [
	^ plugin
]

{ #category : #accessing }
OPEditor >> plugin: aPlugin [
	plugin := aPlugin
]

{ #category : #updating }
OPEditor >> rebuildWidget [
	diagramController ifNotNil: [ paletteModel createPaletteFor: diagramController ].
	canvasModel needRebuild: false.
	self needRebuild: false.
	self buildWithSpec
]

{ #category : #shortcuts }
OPEditor >> registerShortcutsOn: aPresenter [
	shortcuts := self collectShortcuts.
	shortcuts do: [ :each | aPresenter bindKeyCombination: each key toAction: each value ]
]

{ #category : #initialization }
OPEditor >> setModelBeforeInitialization: aPlugin [
	self plugin: aPlugin
	
]

{ #category : #updating }
OPEditor >> tabDeleted [
	self workbench projectController removeDiagramController: diagramController.
	self unregisterShortcutsOn: self workbench.
	diagramController removeAllControllers
]

{ #category : #shortcuts }
OPEditor >> unregisterShortcutsOn: aPresenter [
	shortcuts do: [ :pair | aPresenter removeKeyCombination: pair key ]
]

{ #category : #updating }
OPEditor >> updateUndoRedo [
	| items |
	items := canvasMenuModel menuGroups flatCollect: #menuItems.
	(items detect: [ :each | each name = 'Undo' ])
		enabled: self diagramController hasUndo;
		changed: #enabled with: {self diagramController hasUndo}.
	(items detect: [ :each | each name = 'Redo' ])
		enabled: self diagramController hasRedo;
		changed: #enabled with: {self diagramController hasRedo}
]

{ #category : #'accessing - spec' }
OPEditor >> workbench [
	^ workbench
]

{ #category : #'accessing - spec' }
OPEditor >> workbench: aWorkbench [
	workbench := aWorkbench.
	self registerShortcutsOn: workbench
]

{ #category : #'accessing - spec' }
OPEditor >> zoomLabel [
	^ zoomLabel
]
