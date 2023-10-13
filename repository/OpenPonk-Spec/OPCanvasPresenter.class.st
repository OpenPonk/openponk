"
I am Spec model to embed Roassal2 into DCEditor.
"
Class {
	#name : #OPCanvasPresenter,
	#superclass : #SpRoassalPresenter,
	#instVars : [
		'diagramController',
		'onZoomChange',
		'onExtentChange'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #accessing }
OPCanvasPresenter >> attachController: aDiagramController [

	(diagramController := aDiagramController) canvasPresenter: self
]

{ #category : #accessing }
OPCanvasPresenter >> canvas [

	currentCanvas ifNil: [ 
		self initializeCanvas: (currentCanvas := RSCanvas new) ].
	^ currentCanvas
]

{ #category : #initialization }
OPCanvasPresenter >> connectPresenters [

	super connectPresenters.
	onZoomChange := [ :event |  ].
	onExtentChange := [ :event |  ].
	self whenBuiltDo: [ :adptr |
		CmdKMDispatcher attachedTo: adptr widget withCommandsFrom: self ]
]

{ #category : #'private-focus' }
OPCanvasPresenter >> createCommandContext [
	"Subclases should override it if they provide any selection"

	^ self createCommandContextForSelection: self selectedElements
]

{ #category : #'private-focus' }
OPCanvasPresenter >> createCommandContextForSelection: selectedItems [
	"simple context has no information about selected items"

	^ OPDiagramFigureContext for: self of: selectedItems
]

{ #category : #accessing }
OPCanvasPresenter >> diagramController [
	^ diagramController
]

{ #category : #accessing }
OPCanvasPresenter >> editor [
	^ self owner
]

{ #category : #toolbar }
OPCanvasPresenter >> exportAsPng [

	self flag: 'default name not supported in file browser'.
	OPExportImageDialog new
		title: 'Choose a PNG file to export the diagram';
		okAction: [ :file :zoom | self exportCanvasToPng: file zoom: zoom ];
		extensions: #( png ) named: 'PNG images';
		open
]

{ #category : #toolbar }
OPCanvasPresenter >> exportAsSvg [

	self flag: 'default name not supported in file browser'.
	StFBSaveFileDialog new
		title: 'Choose a SVG file to export the diagram';
		okAction: [ :file | self exportCanvasToSvg: file ];
		extensions: #( svg ) named: 'SVG images';
		"defaultName:
			self editor diagramController model name asFileName , '.svg';"
			open
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToPng: aFile [

	self exportCanvasToPng: aFile silently: false
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToPng: aFile silently: aSilentlyBoolean [

	self
		exportCanvasToPng: aFile
		zoom: 1.0
		silently: aSilentlyBoolean
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToPng: aFileReference zoom: aNumber [

	self exportCanvasToPng: aFileReference zoom: aNumber silently: false
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToPng: aFileReference zoom: aZoom silently: aSilentlyBoolean [

	| originalZoom jobBlock |
	originalZoom := self canvas camera scale.
	self diagramController deselectAll.

	jobBlock := [ :job | 
	            job title: 'Exporting diagram'.
	            [ 
	            self canvas pngExporter
		            cameraSetter: (OPRSCustomScaleCamSetter scale: aZoom);
		            fileName: aFileReference pathString;
		            export ] ensure: [ 
		            job progress: 0.8.
		            self canvas signalUpdate ] ].

	aSilentlyBoolean ifTrue: [ ^ jobBlock value: Job new ].
	jobBlock asJob run.

	UIManager default
		inform: (String streamContents: [ :s | 
				 s << 'Image saved to ' << aFileReference pathString.
				 s
					 cr;
					 cr.
				 s << 'Click to open location' ])
		actionOnClick: [ aFileReference openInOSFileBrowser ]
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToSvg: aFileReference [

	self exportCanvasToSvg: aFileReference silently: false
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToSvg: aFileReference silently: aSilentlyBoolean [

	| jobBlock |
	self diagramController deselectAll.

	jobBlock := [ :job | 
	            job title: 'Exporting diagram'.

	            self canvas svgExporter
		            zoomToShapes;
		            fileName: aFileReference pathString;
		            export ].

	aSilentlyBoolean ifTrue: [ ^ jobBlock value: Job new ].
	jobBlock asJob run.

	UIManager default
		inform: (String streamContents: [ :s | 
				 s << 'Image saved to ' << aFileReference pathString.
				 s
					 cr;
					 cr.
				 s << 'Click to open location' ])
		actionOnClick: [ aFileReference openInOSFileBrowser ]
]

{ #category : #initialization }
OPCanvasPresenter >> initialize [

	super initialize.
	self script: [ :canvas | self initializeCanvas: canvas ]
]

{ #category : #initialization }
OPCanvasPresenter >> initializeCanvas: aCanvas [

	aCanvas
		@ (RSCanvasController new
				 interactionsFromArray: {
						 (RSDraggableCanvasInteraction right
							  hasDraggableAnimation: false;
							  yourself).
						 OPRSKeyNavigationCanvasInteraction new.
						 OPRSZoomableCanvasInteraction new.
						 "OPRSRemoveable new."
						 RSScrollBarsCanvasInteraction new };
				 configuration: (OPRSControlConfiguration new
						  noLegend;
						  hasZoomableAnimation: false;
						  yourself));
		@ OPRSSelectableCanvas rightLeft.

	(aCanvas propertyAt: OPRSSelectableCanvas)
		when: OPRSSelectionEndEvent
		do: [ :evt |
			self
				selectedShapes: evt selectedShapes
				onPosition: evt originalEvent position ]
		for: self.

	aCanvas
		when: RSExtentChangedEvent
		do: [ :event | onExtentChange value: event ]
		for: self.
	aCanvas
		when: RSScaleChangedEvent
		do: [ :event |
			| zoomText |
			zoomText := (event newScale < 1
				             ifTrue: [ '   ' ]
				             ifFalse: [ '' ])
			            , (event newScale * 100) rounded asString , '%'.
			onZoomChange value: event.
			self editor zoomLabel label: ' ' , zoomText ]
		for: self
]

{ #category : #events }
OPCanvasPresenter >> lastClickPosition: aPoint [

	self deprecated: 'Last click is now handled by OPRSEventLogger'
]

{ #category : #accessing }
OPCanvasPresenter >> model [
	^ diagramController model
]

{ #category : #accessing }
OPCanvasPresenter >> roassalView [

	self
		deprecated: 'Use #canvas instead.'
		transformWith:
		'`@receiver roassalView' -> '`@receiver canvas'.
	^ self canvas
]

{ #category : #accessing }
OPCanvasPresenter >> selectedElements [

	^ self diagramController selectedElements
]

{ #category : #'selection handling' }
OPCanvasPresenter >> selectedShapes: shapes onPosition: aPoint [
	self diagramController selectedShapes: shapes onPosition: aPoint
]

{ #category : #signalling }
OPCanvasPresenter >> signalUpdate [
	self canvas signalUpdate
]

{ #category : #accessing }
OPCanvasPresenter >> whenExtentChangedDo:  aOneArgBlock [
	onExtentChange := aOneArgBlock
]

{ #category : #accessing }
OPCanvasPresenter >> whenZoomChanged: aOneArgBlock [
	onZoomChange := aOneArgBlock
]

{ #category : #accessing }
OPCanvasPresenter >> workbench [
	^ self editor workbench
]

{ #category : #accessing }
OPCanvasPresenter >> zoom [
	"1: default zoom
	 2: zoomed in to 200%"

	^ self canvas camera scale
]

{ #category : #accessing }
OPCanvasPresenter >> zoom: aScale [
	"1: default zoom
	 2: zoomed in to 200%"

	(aScale between: 0.05 and: 4)
		ifFalse: [ ^ self ].
	self canvas camera scale: aScale.
	self canvas signalUpdate
]

{ #category : #'as yet unclassified' }
OPCanvasPresenter >> zoomToFit [

	self canvas shapes
		ifEmpty: [ self canvas camera scale: 1 ]
		ifNotEmpty: [ self canvas zoomToFit ]
]
