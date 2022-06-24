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
		'currentLayoutName'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #settings }
OPEditor class >> availableLayoutNames [

	^ self availableLayouts keys
]

{ #category : #settings }
OPEditor class >> availableLayouts [

	^ { 
		  ('Palette on left' asSymbol -> [ self pcfLayout ]).
		  ('Palette on right' asSymbol -> [ self cpfLayout ]) }
		  asOrderedDictionary
]

{ #category : #specs }
OPEditor class >> canvasSectionLayout [

	^ SpBoxLayout newTopToBottom
		  add: #canvasPresenter;
		  add: (SpBoxLayout newLeftToRight
				   add: #canvasMenu;
				   add: #zoomLabel expand: false;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : #settings }
OPEditor class >> canvasSectionWidth [

	^ OPWorkbench initialExtent x - OPWorkbench initialListsWidth
	  - OPPalette initialWidth - OPDynamicForm initialWidth
]

{ #category : #settings }
OPEditor class >> cpfLayout [

	"[ [ Canvas | Palette ] | Form ]"

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: self canvasSectionWidth + OPPalette initialWidth;
		  add: (SpPanedLayout newLeftToRight
				   positionOfSlider: self canvasSectionWidth;
				   add: self canvasSectionLayout;
				   add: self paletteSectionLayout;
				   yourself);
		  add: self formSectionLayout;
		  yourself
]

{ #category : #settings }
OPEditor class >> currentLayout [

	^ self layoutNamed: self layoutStyle
]

{ #category : #specs }
OPEditor class >> defaultLayout [

	^ self pcfLayout
]

{ #category : #settings }
OPEditor class >> defaultLayoutName [

	^ self availableLayoutNames first
]

{ #category : #toolbar }
OPEditor class >> developerToolbarMenu: aBuilder [
	OPWorkbench isDevelopmentMode
		ifFalse: [ ^ self ].
	(aBuilder item: 'Inspect Controller...')
		action: [ aBuilder model diagramController inspect ].
	aBuilder withSeparatorAfter
]

{ #category : #settings }
OPEditor class >> formSectionLayout [

	^ self scrollableTabWith: #form label: 'Properties'
]

{ #category : #settings }
OPEditor class >> layoutNamed: aString [

	^ (self availableLayouts
		   at: aString asSymbol
		   ifAbsent: [ self defaultLayout ]) value
]

{ #category : #settings }
OPEditor class >> layoutStyle [
	^ currentLayoutName ifNil: [ self setDefaultLayoutStyle ]
]

{ #category : #settings }
OPEditor class >> layoutStyle: aStyle [

	currentLayoutName := aStyle.
	self allInstances
		select: [ :each | 
			| isWindowOpen |
			isWindowOpen := false.
			each withWindowDo: [ :window | isWindowOpen := window isOpen ].
			isWindowOpen ]
		thenDo: [ :each | each layout: self currentLayout ]
]

{ #category : #settings }
OPEditor class >> paletteSectionLayout [

	^ self scrollableTabWith: #palette label: 'Palette'
]

{ #category : #settings }
OPEditor class >> pcfLayout [

	"[ Palette | [ Canvas | Form ] ]"

	^ SpPanedLayout newLeftToRight
		  positionOfSlider: 200;
		  add: self paletteSectionLayout;
		  add: (SpPanedLayout newLeftToRight
				   positionOfSlider: self canvasSectionWidth;
				   add: self canvasSectionLayout;
				   add: self formSectionLayout;
				   yourself);
		  yourself
]

{ #category : #settings }
OPEditor class >> scrollableTabWith: aContent label: aTabLabel [

	^ SpBoxLayout newTopToBottom
		  add: (OPTabHeaderPresenter labelled: aTabLabel) expand: false;
		  spacing: 10;
		  add: (SpScrollableLayout with: (SpBoxLayout newTopToBottom
						    add: aContent expand: false;
						    add: (SpLabelPresenter new
								     label: '';
								     yourself)
						    expand: false;
						    yourself));
		  yourself
]

{ #category : #settings }
OPEditor class >> setDefaultLayoutStyle [

	<script>
	^ currentLayoutName := self defaultLayoutName
]

{ #category : #settings }
OPEditor class >> settingsOn: aBuilder [

	<systemsettings>
	(aBuilder pickOne: #layoutStyle)
		parent: #openponk;
		target: self;
		label: 'Form-Palette Layout Style';
		description:
			'Show form below (vertical) or next to (horizontal) palette.';
		default: self defaultLayoutName;
		domainValues: self availableLayoutNames;
		order: 40
]

{ #category : #toolbar }
OPEditor class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu>
	self developerToolbarMenu: aBuilder.
	(aBuilder item: 'Export as PNG...') action: [ 
		aBuilder model canvasPresenter exportAsPng ].
	(aBuilder item: 'Export as SVG (incomplete/simplified)...') action: [ 
		aBuilder model canvasPresenter exportAsSvg ]
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
	self layout: self newNullPresenter.
	self layout: self class currentLayout
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
	self rebuildWidget.
	canvasPresenter attachController: diagramController
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
	canvasPresenter needRebuild: false.
	canvasPresenter update.
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

{ #category : #'diagram handling' }
OPEditor >> showDiagram: aDiagram [
	diagramController diagram: aDiagram.
	diagramController rebuild
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
