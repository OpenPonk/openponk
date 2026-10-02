"
Spec presenter responsible for embedding the Roassal canvas into the OpenPonk editor. Bridges user interactions on the canvas (like zooming, panning, and selections) to the OPDiagramController, and manages diagram export functionalities (PDF, PNG, SVG).
"
Class {
	#name : 'OPCanvasPresenter',
	#superclass : 'SpRoassalPresenter',
	#instVars : [
		'diagramController',
		'onZoomChange',
		'onExtentChange'
	],
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'accessing' }
OPCanvasPresenter >> attachController: aDiagramController [

	(diagramController := aDiagramController) canvasPresenter: self
]

{ #category : 'accessing' }
OPCanvasPresenter >> canvas [

	currentCanvas ifNil: [ 
		self initializeCanvas: (currentCanvas := RSCanvas new) ].
	^ currentCanvas
]

{ #category : 'accessing' }
OPCanvasPresenter >> canvas: aCanvas [
	currentCanvas := aCanvas.
	self initializeCanvas: currentCanvas.
	^ currentCanvas
]

{ #category : 'initialization' }
OPCanvasPresenter >> connectPresenters [
	super connectPresenters.
	self whenBuiltDo: [ :adptr |
		CmdKMDispatcher attachedTo: adptr widget withCommandsFrom: self ]
]

{ #category : 'private-focus' }
OPCanvasPresenter >> createCommandContext [
	"Subclases should override it if they provide any selection"

	^ self createCommandContextForSelection: self selectedElements
]

{ #category : 'private-focus' }
OPCanvasPresenter >> createCommandContextForSelection: selectedItems [
	"simple context has no information about selected items"

	^ OPRoassalShapeContext for: self of: selectedItems
]

{ #category : 'exporting' }
OPCanvasPresenter >> defaultExportFileNameWithExtension: anExtension [
	| baseName |
	baseName := self diagramController
		ifNotNil: [ :activeDiagramController |
			activeDiagramController viewModel
				ifNotNil: [ :activeViewModel | activeViewModel nameOfModel ] ]
		ifNil: [ nil ].
	(baseName isNil or: [ baseName trimBoth isEmpty ])
		ifTrue: [ baseName := 'diagram' ].
	^ (FileNameSanitizer sanitize: baseName trimBoth) , '.' , anExtension
]

{ #category : 'exporting' }
OPCanvasPresenter >> defaultExportFolder [
	self workbench ifNotNil: [ :activeWorkbench |
		activeWorkbench projectController ifNotNil: [ :currentProjectController |
			currentProjectController project ifNotNil: [ :currentProject |
				currentProject storageFile ifNotNil: [ :file |
					file parent ifNotNil: [ :folder |
						folder exists ifTrue: [ ^ folder ] ] ].
				currentProject storageFolder ifNotNil: [ :folder |
					folder exists ifTrue: [ ^ folder ] ] ] ] ].
	^ FileSystem workingDirectory
]

{ #category : 'accessing' }
OPCanvasPresenter >> diagramController [
	^ diagramController
]

{ #category : 'accessing' }
OPCanvasPresenter >> diagramController: aDiagramController [
	diagramController := aDiagramController
]

{ #category : 'accessing' }
OPCanvasPresenter >> editor [
	^ self owner
]

{ #category : 'toolbar' }
OPCanvasPresenter >> exportAsPdf [
	| dialog |
	dialog := StSaveFilePresenter new
		title: 'Choose a PDF file to export the diagram';
		nameText: (self defaultExportFileNameWithExtension: 'pdf');
		defaultFolder: self defaultExportFolder;
		okAction: [ :file |
			self exportWithCleanCanvasDo: [
				OPCanvasPDFExporter
					exportDiagramController: diagramController
					to: file ] ];
		extensions: #( pdf ) named: 'PDF documents';
		yourself.
	dialog openModal
]

{ #category : 'toolbar' }
OPCanvasPresenter >> exportAsPng [
	| dialog |
	dialog := OPExportImageDialog new
		title: 'Choose a PNG file to export the diagram';
		nameText: (self defaultExportFileNameWithExtension: 'png');
		defaultFolder: self defaultExportFolder;
		okAction: [ :file :zoom |
			self exportWithCleanCanvasDo: [
				OPCanvasPNGExporter
					exportDiagramController: diagramController
					to: file
					zoom: zoom ] ];
		extensions: #( png ) named: 'PNG images';
		yourself.
	dialog openModal
]

{ #category : 'toolbar' }
OPCanvasPresenter >> exportAsPng: aFile [

	OPCanvasPNGExporter
		exportDiagramController: diagramController
		to: aFile
]

{ #category : 'toolbar' }
OPCanvasPresenter >> exportAsSvg [
	| dialog |
	dialog := StSaveFilePresenter new
		title: 'Choose a SVG file to export the diagram';
		nameText: (self defaultExportFileNameWithExtension: 'svg');
		defaultFolder: self defaultExportFolder;
		okAction: [ :file |
			self exportWithCleanCanvasDo: [
				OPCanvasSVGExporter
					exportDiagramController: diagramController
					to: file ] ];
		extensions: #( svg ) named: 'SVG images';
		yourself.
	dialog openModal
]

{ #category : 'exporting' }
OPCanvasPresenter >> exportWithCleanCanvasDo: aBlock [
	^ self diagramController
		ifNotNil: [ :activeDiagramController | activeDiagramController withoutSelectionDo: aBlock ]
		ifNil: [ aBlock value ]
]

{ #category : 'initialization' }
OPCanvasPresenter >> initialize [
	super initialize.
	onZoomChange := [ :event | ].
	onExtentChange := [ :event | ].
	self script: [ :canvas | self initializeCanvas: canvas ]
]

{ #category : 'initialization' }
OPCanvasPresenter >> initializeCanvas: aCanvas [
	aCanvas
		@ (RSCanvasController new
				 interactionsFromArray: {
						 (RSDraggableCanvasInteraction right
							  hasDraggableAnimation: false;
							  yourself).
						 OPRSKeyNavigationCanvasInteraction new.
						 RSZoomableCanvasInteraction new.
						 RSScrollBarsCanvasInteraction new };
				 configuration: (OPRSControlConfiguration new
						  noLegend;
						  shouldAnimateZoom: false;
						  yourself));
		@ OPRSSelectableCanvas.

	(aCanvas propertyAt: OPRSSelectableCanvas)
		when: OPRSSelectionEndEvent
		do: [ :evt |
			self
				selectedShapes: evt selectedShapes
				onPosition: evt originalEvent position ]
		for: self.

	aCanvas
		when: RSExtentChangedEvent
		do: [ :event | onExtentChange ifNotNil: [ onExtentChange cull: event ] ]
		for: self.
	aCanvas
		when: RSScaleChangedEvent
		do: [ :event | onZoomChange ifNotNil: [ onZoomChange cull: event ] ]
		for: self
]

{ #category : 'accessing' }
OPCanvasPresenter >> model [
	^ diagramController model
]

{ #category : 'accessing' }
OPCanvasPresenter >> roassalView [

	self
		deprecated: 'Use #canvas instead.'
		transformWith:
		'`@receiver roassalView' -> '`@receiver canvas'.
	^ self canvas
]

{ #category : 'accessing' }
OPCanvasPresenter >> selectedElements [

	^ self diagramController selectedElements
]

{ #category : 'selection handling' }
OPCanvasPresenter >> selectedShapes: shapes onPosition: aPoint [
	self diagramController selectedShapes: shapes onPosition: aPoint
]

{ #category : 'signalling' }
OPCanvasPresenter >> signalUpdate [
	self canvas signalUpdate
]

{ #category : 'accessing' }
OPCanvasPresenter >> whenExtentChangedDo:  aOneArgBlock [
	onExtentChange := aOneArgBlock
]

{ #category : 'accessing' }
OPCanvasPresenter >> whenZoomChanged: aOneArgBlock [
	onZoomChange := aOneArgBlock
]

{ #category : 'accessing' }
OPCanvasPresenter >> workbench [
	^ self editor workbench
]

{ #category : 'accessing' }
OPCanvasPresenter >> zoom [
	"1: default zoom
	 2: zoomed in to 200%"

	^ self canvas camera scale
]

{ #category : 'accessing' }
OPCanvasPresenter >> zoom: aScale [
	"1: default zoom
	 2: zoomed in to 200%"

	(aScale between: 0.05 and: 4)
		ifFalse: [ ^ self ].
	self canvas camera scale: aScale.
	self canvas signalUpdate
]

{ #category : 'zoom' }
OPCanvasPresenter >> zoomToFit [

	self canvas shapes
		ifEmpty: [ self canvas camera scale: 1 ]
		ifNotEmpty: [ self canvas zoomToFit ]
]
