"
I am a component for visualization and manipulation of diagrams.
I consist of canvas (Roassal's RTView) and a palette which depends on the type of diagram.
I am bound with a diagram package and cannot live without it.
"
Class {
	#name : 'OPEditor',
	#superclass : 'SpPresenter',
	#instVars : [
		'workbench',
		'zoomLabel',
		'diagramController',
		'plugin',
		'canvasPresenter',
		'canvasMenu',
		'form',
		'palette'
	],
	#classInstVars : [
		'currentLayout'
	],
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'settings' }
OPEditor class >> availableLayoutNames [

	^ self availableLayouts collect: #name
]

{ #category : 'settings' }
OPEditor class >> availableLayouts [

	^ OPEditorLayout all
]

{ #category : 'settings' }
OPEditor class >> canvasSectionWidth [

	^ OPWorkbench initialExtent x - OPWorkbench initialListsWidth
	  - OPPalette initialWidth - OPDynamicForm initialWidth
]

{ #category : 'settings' }
OPEditor class >> currentLayout [

	currentLayout ifNil: [ self setDefaultLayout ].
	^ currentLayout
]

{ #category : 'settings' }
OPEditor class >> defaultLayout [

	^ OPEditorLayout default
]

{ #category : 'toolbar' }
OPEditor class >> developerToolbarMenu: aBuilder [

	(aBuilder item: 'Inspect Controller...')
		icon: (self iconNamed: #glamorousInspect);
		action: [ aBuilder model diagramController inspect ].
	aBuilder withSeparatorAfter
]

{ #category : 'toolbar' }
OPEditor class >> diagramExportMenu: aBuilder [

	(aBuilder item: #diagramExport)
		label: 'Export diagram as...';
		icon: (self iconNamed: #smallScreenshot).

	(aBuilder item: 'Export as PNG...')
		parent: #diagramExport;
		action: [ aBuilder model canvasPresenter exportAsPng ].
	(aBuilder item: 'Export as SVG...')
		parent: #diagramExport;
		action: [ aBuilder model canvasPresenter exportAsSvg ].
	(aBuilder item: 'Export as PDF...')
		parent: #diagramExport;
		action: [ aBuilder model canvasPresenter exportAsPdf ]
]

{ #category : 'settings' }
OPEditor class >> layoutName [

	^ self currentLayout name
]

{ #category : 'settings' }
OPEditor class >> layoutName: aLayoutName [

	currentLayout := OPEditorLayout named: aLayoutName.
	self allInstances
		select: [ :each | 
			| isWindowOpen |
			isWindowOpen := false.
			each withWindowDo: [ :window | isWindowOpen := window isOpen ].
			isWindowOpen ]
		thenDo: [ :each | 
			currentLayout applyOn: each ]
]

{ #category : 'settings' }
OPEditor class >> setDefaultLayout [

	<script>
	self layoutName: self defaultLayout name
]

{ #category : 'settings' }
OPEditor class >> settingsOn: aBuilder [

	<systemsettings>
	(aBuilder pickOne: #layoutName)
		parent: #openponk;
		target: self;
		label: 'Editor Layout Style';
		description:
			'Show palette on the left or right of main canvas.';
		default: self defaultLayout name;
		domainValues: self availableLayoutNames;
		order: 40
]

{ #category : 'toolbar' }
OPEditor class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu>
	self developerToolbarMenu: aBuilder.
	self diagramExportMenu: aBuilder
]

{ #category : 'accessing - spec' }
OPEditor >> canvasMenu [
	^ canvasMenu
]

{ #category : 'accessing - spec' }
OPEditor >> canvasPresenter [
	^ canvasPresenter
]

{ #category : 'initialization' }
OPEditor >> connectPresenters [

	| menu |
	menu := OPDiagramToolbarActivation buildMenuInContext:
		        (CmdSimpleToolContext for: canvasPresenter).
	menu buildSpecMenuOn: canvasMenu
]

{ #category : 'private-focus' }
OPEditor >> createCommandContext [
	"Subclases should override it if they provide any selection"

	^ canvasPresenter createCommandContext
]

{ #category : 'accessing' }
OPEditor >> diagramController [
	^ diagramController
]

{ #category : 'accessing - spec' }
OPEditor >> form [
	^ form
]

{ #category : 'initialization' }
OPEditor >> initializePresenters [

	canvasMenu := self newMenuBar.
	canvasPresenter := self instantiate: OPCanvasPresenter.
	palette := self instantiate: OPPalette.
	form := self instantiate: OPDynamicForm.
	(zoomLabel := self newLabel) label: '100%'.
	self focusOrder
		add: canvasMenu;
		add: canvasPresenter;
		add: palette;
		add: form.
	self class currentLayout applyOn: self.

	self whenBuiltDo: [ :builtEvent |
		self withWindowDo: [ :window |
			| minimized |
			minimized := false.
			window window announcer
				when: WindowCollapsed
				do: [ minimized := true ]
				for: self.
			window window announcer
				when: WindowExpanded
				do: [ minimized := false ]
				for: self.
			window whenResizingDo: [ :resizeEvent |
				minimized ifFalse: [
					self class currentLayout
						resizePanelsOf: builtEvent widget
						afterWindowResized: resizeEvent ] ].
			window whenClosedDo: [
				window window announcer unsubscribe: self.
				diagramController removeAllControllers ] ] ]
]

{ #category : 'diagram handling' }
OPEditor >> newDiagramControllerFor: aModel [
	^ plugin diagramControllerClass new
		model: aModel;
		editor: self;
		workbenchAnnouncer: self workbench announcer;
		yourself
]

{ #category : 'diagram handling' }
OPEditor >> openEmptyModel: aModel [

	diagramController := self newDiagramControllerFor: aModel.
	self workbench projectController addDiagramController:
		diagramController.
	canvasPresenter attachController: diagramController.
	self rebuildWidget
]

{ #category : 'initialization' }
OPEditor >> openFormOn: aController [

	form editController: aController
]

{ #category : 'accessing' }
OPEditor >> palette [

	^ palette
]

{ #category : 'accessing' }
OPEditor >> plugin [
	^ plugin
]

{ #category : 'accessing' }
OPEditor >> plugin: aPlugin [
	plugin := aPlugin
]

{ #category : 'updating' }
OPEditor >> rebuildWidget [

	diagramController ifNotNil: [ 
		palette createPaletteFor: diagramController ].
	self update
]

{ #category : 'initialization' }
OPEditor >> setModelBeforeInitialization: aPlugin [
	self plugin: aPlugin
	
]

{ #category : 'updating' }
OPEditor >> tabDeleted [

	self workbench projectController updateDiagram:
		diagramController diagramElement.
	self workbench projectController removeDiagramController:
		diagramController.
	diagramController removeRender
]

{ #category : 'updating' }
OPEditor >> updateUndoRedo [
	self flag: #unused.
	"
	| items |
	items := canvasPresenter menuGroups flatCollect: #menuItems.
	(items detect: [ :each | each name = 'Undo' ])
		enabled: self diagramController hasUndo;
		changed: #enabled with: {self diagramController hasUndo}.
	(items detect: [ :each | each name = 'Redo' ])
		enabled: self diagramController hasRedo;
		changed: #enabled with: {self diagramController hasRedo}"
]

{ #category : 'accessing - spec' }
OPEditor >> workbench [
	^ workbench
]

{ #category : 'accessing - spec' }
OPEditor >> workbench: aWorkbench [

	workbench := aWorkbench
]

{ #category : 'accessing - spec' }
OPEditor >> zoomLabel [
	^ zoomLabel
]
