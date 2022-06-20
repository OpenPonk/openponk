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
OPEditor class >> availableLayoutDifferences [

	| singlePaneWidth |
	singlePaneWidth := 250.
	^ { 
		  (#horizontal -> { 
			   (#layout -> SpPanedLayout newLeftToRight).
			   (#width -> (singlePaneWidth * 2)) } asDictionary).
		  (#vertical -> { 
			   (#layout -> SpPanedLayout newTopToBottom).
			   (#width -> singlePaneWidth) } asDictionary) } asDictionary
]

{ #category : #settings }
OPEditor class >> availableLayoutNames [

	^ self availableLayoutDifferences keys
]

{ #category : #specs }
OPEditor class >> commonLayoutWithFormPaletteLayout: aBoxLayout width: aWidthOfRightPanes [

	^ SpPanedLayout newLeftToRight
		  positionOfSlider:
			  OPWorkbench initialExtent x - OPWorkbench initialListsWidth
			  - aWidthOfRightPanes;
		  add: (SpBoxLayout newTopToBottom
				   add: #canvasPresenter;
				   add: (SpBoxLayout newLeftToRight
						    add: #canvasMenu;
						    add: #zoomLabel width: 35;
						    yourself)
				   height: self toolbarHeight - 1;
				   yourself);
		  add: (aBoxLayout
				   add: #palette;
				   add: #form;
				   yourself) yourself
]

{ #category : #settings }
OPEditor class >> currentLayout [

	^ self layoutNamed: self layoutStyle
]

{ #category : #settings }
OPEditor class >> defaultLayoutName [

	^ #horizontal
]

{ #category : #specs }
OPEditor class >> defaultSpec [

	self flag: 'Pharo 9- compatibility'.
	^ self horizontalLayout
]

{ #category : #toolbar }
OPEditor class >> developerToolbarMenu: aBuilder [
	OPWorkbench isDevelopmentMode
		ifFalse: [ ^ self ].
	(aBuilder item: 'Inspect Controller...')
		action: [ aBuilder model diagramController inspect ].
	aBuilder withSeparatorAfter
]

{ #category : #specs }
OPEditor class >> horizontalLayout [

	^ self layoutNamed: #horizontal
]

{ #category : #settings }
OPEditor class >> layoutNamed: aString [

	| layoutDetails |
	layoutDetails := self availableLayoutDifferences at: aString asSymbol.
	^ self
		  commonLayoutWithFormPaletteLayout: (layoutDetails at: #layout)
		  width: (layoutDetails at: #width)
]

{ #category : #settings }
OPEditor class >> layoutStyle [
	^ currentLayoutName ifNil: [ currentLayoutName := self defaultLayoutName ]
]

{ #category : #settings }
OPEditor class >> layoutStyle: aStyle [

	currentLayoutName := aStyle.
	self allInstances
		select: [ :each | each isOpen ]
		thenDo: [ :each | each layout: self currentLayout ]
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

{ #category : #specs }
OPEditor class >> verticalLayout [

	^ self layoutNamed: #vertical
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
	super ensureKeyBindingsFor: aWidget.
	^self enableCommanderShortcutsIn: aWidget
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
