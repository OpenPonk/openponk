"
I am a component for visualization and manipulation of diagrams.
I consist of canvas (Roassal's RTView) and a palette which depends on the type of diagram.
I am bound with a diagram package and cannot live without it.
"
Class {
	#name : #OPEditor,
	#superclass : #SpPresenter,
	#instVars : [
		'workbench',
		'zoomLabel',
		'diagramController',
		'plugin',
		'shortcuts',
		'canvasPresenter',
		'canvasMenu',
		'form',
		'palette'
	],
	#classInstVars : [
		'currentLayout'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #settings }
OPEditor class >> availableLayoutNames [

	^ self availableLayouts collect: #name
]

{ #category : #settings }
OPEditor class >> availableLayouts [

	^ OPEditorLayout all
]

{ #category : #settings }
OPEditor class >> canvasSectionWidth [

	^ OPWorkbench initialExtent x - OPWorkbench initialListsWidth
	  - OPPalette initialWidth - OPDynamicForm initialWidth
]

{ #category : #settings }
OPEditor class >> currentLayout [

	currentLayout ifNil: [ self setDefaultLayout ].
	^ currentLayout
]

{ #category : #settings }
OPEditor class >> defaultLayout [

	^ OPEditorLayout default
]

{ #category : #toolbar }
OPEditor class >> developerToolbarMenu: aBuilder [

	OPWorkbench isDevelopmentMode ifFalse: [ ^ self ].
	(aBuilder item: 'Inspect Controller...')
		icon: (self iconNamed: #glamorousInspect);
		action: [ aBuilder model diagramController inspect ].
	aBuilder withSeparatorAfter
]

{ #category : #settings }
OPEditor class >> layoutName [

	^ self currentLayout name
]

{ #category : #settings }
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

{ #category : #settings }
OPEditor class >> setDefaultLayout [

	<script>
	self layoutName: self defaultLayout name
]

{ #category : #settings }
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

{ #category : #toolbar }
OPEditor class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu>
	self developerToolbarMenu: aBuilder.
	(aBuilder item: 'Export as PNG...')
		icon: (self iconNamed: #smallScreenshot);
		action: [ aBuilder model canvasPresenter exportAsPng ].
	(aBuilder item: 'Export as SVG (incomplete/simplified)...')
		icon: (self iconNamed: #smallScreenshot);
		action: [ aBuilder model canvasPresenter exportAsSvg ]
]

{ #category : #'accessing - spec' }
OPEditor >> canvasMenu [
	^ canvasMenu
]

{ #category : #'accessing - spec' }
OPEditor >> canvasPresenter [
	^ canvasPresenter
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

{ #category : #'as yet unclassified' }
OPEditor >> connectPresenters [

	| menu |
	menu := OPDiagramToolbarActivation buildMenuInContext:
		        (CmdSimpleToolContext for: canvasPresenter).
	menu buildSpecMenuOn: canvasMenu
]

{ #category : #'private-focus' }
OPEditor >> createCommandContext [
	"Subclases should override it if they provide any selection"

	^ canvasPresenter createCommandContext
]

{ #category : #accessing }
OPEditor >> diagramController [
	^ diagramController
]

{ #category : #'private-focus' }
OPEditor >> ensureKeyBindingsFor: aWidget [

	self flag: 'Does not work in P11'.
	super ensureKeyBindingsFor: aWidget.
	^ self enableCommanderShortcutsIn: aWidget
]

{ #category : #'accessing - spec' }
OPEditor >> form [
	^ form
]

{ #category : #'as yet unclassified' }
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
				do: [ minimized := true ].
			window window announcer
				when: WindowExpanded
				do: [ minimized := false ].
			window whenResizingDo: [ :resizeEvent | 
				minimized ifFalse: [ 
					self class currentLayout
						resizePanelsOf: builtEvent widget
						afterWindowResized: resizeEvent ] ].
			window whenClosedDo: [ 
				window window announcer unsubscribe: self.
				diagramController removeController ] ] ]
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
	self workbench projectController addDiagramController:
		diagramController.
	canvasPresenter attachController: diagramController.
	self rebuildWidget
]

{ #category : #'as yet unclassified' }
OPEditor >> openFormOn: aController [

	form editController: aController
]

{ #category : #accessing }
OPEditor >> palette [

	^ palette
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

	diagramController ifNotNil: [ 
		palette createPaletteFor: diagramController ].
	self update
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

	self workbench projectController updateDiagram:
		diagramController diagram.
	self workbench projectController removeDiagramController:
		diagramController.
	self unregisterShortcutsOn: self workbench.
	diagramController removeAllControllers
]

{ #category : #shortcuts }
OPEditor >> unregisterShortcutsOn: aPresenter [
	shortcuts do: [ :pair | aPresenter removeKeyCombination: pair key ]
]

{ #category : #updating }
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
