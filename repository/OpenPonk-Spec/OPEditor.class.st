"
Core Spec presenter for visualizing and editing a diagram. 
Coordinates the rendering canvas (Roassal), the palette of tools, and the governing OPDiagramController for a specific instance of a diagram (visual representation of a model).
"
Class {
	#name : 'OPEditor',
	#superclass : 'SpPresenter',
	#instVars : [
		'workbench',
		'diagramController',
		'plugin',
		'canvasPresenter',
		'palette',
		'zoomToolbar'
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

	^ OPWorkbench initialWidth - OPWorkbench initialListsWidth - OPPalette initialWidth - OPPropertiesForm initialWidth
]

{ #category : 'settings' }
OPEditor class >> currentLayout [

	currentLayout ifNil: [ self setDefaultLayout ].
	^ currentLayout
]

{ #category : 'layout' }
OPEditor class >> defaultLayout [

	^ OPEditorLayout default
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

{ #category : 'accessing - spec' }
OPEditor >> canvasPresenter [
	^ canvasPresenter
]

{ #category : 'initialization' }
OPEditor >> connectPresenters [
	"Connects presenter events and hooks lifecycle announcements."
	super connectPresenters
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

	^ self workbench form
]

{ #category : 'initialization' }
OPEditor >> initializePresenters [
	"Initializes the child presenters and configures the editor window lifecycle."
	canvasPresenter := self instantiate: OPCanvasPresenter.
	zoomToolbar := self instantiate: OPZoomToolbarPresenter on: canvasPresenter.
	palette := self instantiate: OPPalette.
	self focusOrder
		add: canvasPresenter;
		add: zoomToolbar;
		add: palette.
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
				diagramController ifNotNil: [ :activeDiagramController | 
					activeDiagramController removeAllControllers ] ] ] ]
]

{ #category : 'initialization' }
OPEditor >> newDiagramControllerFor: aModel [
	| newDiagramController |
	newDiagramController := plugin diagramControllerClass new.
	self workbench projectController addDiagramController: newDiagramController.
	^ newDiagramController
		editor: self;
		workbenchAnnouncer: self workbench announcer;
		model: aModel;
		yourself
]

{ #category : 'opening' }
OPEditor >> openEmptyModel: aModel [
	diagramController := self newDiagramControllerFor: aModel.
	canvasPresenter attachController: diagramController.
	self rebuildWidget
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

{ #category : 'accessing - model' }
OPEditor >> setModelBeforeInitialization: aPlugin [
	self plugin: aPlugin
	
]

{ #category : 'tabs' }
OPEditor >> tabClosedWhileClosingWorkbench: closingWorkbench [
	diagramController ifNotNil: [ :activeDiagramController |
		activeDiagramController diagramElement ifNotNil: [ :activeDiagram |
			self workbench projectController updateDiagram: activeDiagram ] ].
	closingWorkbench ifFalse: [
		self workbench projectController removeDiagramController: diagramController ].
	diagramController removeController
]

{ #category : 'accessing - spec' }
OPEditor >> workbench [

	^ workbench
]

{ #category : 'accessing - spec' }
OPEditor >> workbench: aWorkbench [

	workbench := aWorkbench
]

{ #category : 'accessing' }
OPEditor >> zoomToolbar [
	"Answers the presenter providing viewport navigation controls."
	^ zoomToolbar
]
