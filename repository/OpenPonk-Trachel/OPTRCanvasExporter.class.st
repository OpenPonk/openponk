"
A TRCanvasExporter is exporter of Trachel canvas into image.
	
Supported formats: png, jpg (jpeg), bmp, gif.

There are 3 types of settings
	- immediate - makes change immediately
	- before export - makes change once right before first export occurs, only last value provided to method is used
	- in time of export - setting applied in time of each export, last provided value before the export is used
	
See example on class side or look into methods in settings protocol.

"
Class {
	#name : #OPTRCanvasExporter,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'fileName',
		'imageExporter',
		'format',
		'oversize',
		'margin',
		'finalized'
	],
	#category : 'OpenPonk-Trachel-Core'
}

{ #category : #initialization }
OPTRCanvasExporter class >> canvas: aCanvas [
	^ self new
		canvas: aCanvas;
		yourself
]

{ #category : #example }
OPTRCanvasExporter class >> example01 [
	| b view |
	b := RTMondrian new.
	b nodes: RTShape withAllSubclasses.
	b edges connectFrom: #superclass.
	b layout tree.
	b build.

	view := b view.
	(self canvas: view canvas)
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 20 @ 20;
		asPNG;
		fileName: ((UIManager default request: 'Please enter file name' initialAnswer: 'export.png') ifNil: [ ^ nil ]);
		export;
		fileName: 'export.jpg';
		asJPG;
		export
]

{ #category : #private }
OPTRCanvasExporter >> applyMargin [
	"permanently adds selected margin to size of canvas"

	self extent: self extent + margin + margin
]

{ #category : #private }
OPTRCanvasExporter >> applyOversize [
	"permanently adds selected oversize to size of canvas"

	self extent: self extent + (self cameraScale * oversize)
]

{ #category : #settings }
OPTRCanvasExporter >> asBMP [
	"Setting applied in time of export."

	format := #bmp.
	imageExporter := BMPReadWriter
]

{ #category : #settings }
OPTRCanvasExporter >> asGIF [
	"Setting applied in time of export."

	format := #gif.
	imageExporter := GIFReadWriter
]

{ #category : #settings }
OPTRCanvasExporter >> asJPEG [
	"Setting applied in time of export."

	self asJPG
]

{ #category : #settings }
OPTRCanvasExporter >> asJPG [
	"Setting applied in time of export."

	format := #jpg.
	imageExporter := PluginBasedJPEGReadWriter
]

{ #category : #settings }
OPTRCanvasExporter >> asPNG [
	"Setting applied in time of export."

	format := #png.
	imageExporter := PNGReadWriter
]

{ #category : #accessing }
OPTRCanvasExporter >> cameraScale [
	^ canvas camera scale
]

{ #category : #settings }
OPTRCanvasExporter >> cameraScale: aScale [
	"Setting applied immediately.
	Changes scale of content of image, but does not change its extent (use #scale: for that)"

	canvas camera doWithoutCallbacks: [ canvas camera scale: aScale ]
]

{ #category : #settings }
OPTRCanvasExporter >> canvas: aCanvas [
	"sets canvas for export, resets all immediate settings"

	canvas := aCanvas veryDeepCopy.
	canvas morph
		ifNil: [ 
			canvas buildMorph.
			self whole ].
	self initialize
]

{ #category : #settings }
OPTRCanvasExporter >> centered [
	"Setting applied immediately.
	Makes image center to be at the center of canvas"

	canvas camera doWithoutCallbacks: [ canvas camera focusOnCenter ]
]

{ #category : #settings }
OPTRCanvasExporter >> defaultScale [
	"Setting applied immediately.
	Changes scale to default one"

	self scale: (TRCamera forCanvas: canvas) defaultCameraScale
]

{ #category : #export }
OPTRCanvasExporter >> export [
	"Makes the export itself. Repeatable last step of process. Do not change any settings after export has been made."

	self performFinalOperations.
	imageExporter putForm: canvas morph imageForm onFileNamed: fileName value
]

{ #category : #accessing }
OPTRCanvasExporter >> extent [
	^ canvas morph extent
]

{ #category : #settings }
OPTRCanvasExporter >> extent: anExtent [
	"Setting applied immediately.
	Sets size of image, revealing less or more of canvas."

	canvas morph extent: anExtent
]

{ #category : #settings }
OPTRCanvasExporter >> fileName: aFileName [
	"Setting applied in time of export."

	fileName := aFileName
]

{ #category : #accessing }
OPTRCanvasExporter >> format [
	"Symbol with format (extension) of image"

	^ format
]

{ #category : #initialization }
OPTRCanvasExporter >> initialize [
	self asPNG
		fileName: [ 'export.' , format ];
		oversizedBy: 0 @ 0.
	finalized := false.
	margin := 0 @ 0
]

{ #category : #settings }
OPTRCanvasExporter >> margin: anExtent [
	"Setting applied right before exports.
	Applies margin on all sides of image in the moment of export. Ignores scale.
	margin: 10@20. => extent increased by 20@40 (10 on left and right, 20 on top and bottom)"

	margin := anExtent
]

{ #category : #settings }
OPTRCanvasExporter >> oversizedBy: anExtent [
	"Setting applied right before exports.
	Increases extent by anExtent, multiplied by scale in the moment of export.
oversizedBy: 10@10. scale: 2. => extent increased by 20@20"

	oversize := anExtent
]

{ #category : #private }
OPTRCanvasExporter >> performFinalOperations [
	"Last step before export.
Due to applying oversize and scaling to morph limits it is recommended to use only once for single instance right before exporting."

	canvas ifNil: [ self error: 'No canvas selected' ].
	fileName ifNil: [ self error: 'File name not set' ].
	self
		applyOversize;
		scaleToMorphLimits;
		applyMargin.
	finalized := true
]

{ #category : #settings }
OPTRCanvasExporter >> scale: aScale [
	"Setting applied immediately.
	Resizes image and its content to aScale
	1 = defaultScale
	2 = 200% zoom in"

	self
		extent: self extent * aScale / self cameraScale;
		cameraScale: aScale
]

{ #category : #settings }
OPTRCanvasExporter >> scaleToExtent: anExtent [
	"Setting applied immediately.
	Sets size of image, scaling canvas to show the same part of canvas (with possible enlarging in one axis based on aspect ratio)."

	| minRatio |
	minRatio := anExtent x / self extent x min: anExtent y / self extent y.
	self
		scale: self cameraScale * minRatio;
		extent: anExtent
]

{ #category : #private }
OPTRCanvasExporter >> scaleToMorphLimits [
	"scale down to estimated morph (maxWidthAndHeight) and exporter (maxArea) size limits"

	| maxArea maxWidthAndHeight maxWidth maxHeight |
	maxArea := 32000000.
	maxWidthAndHeight := 10000.

	maxWidth := maxWidthAndHeight - (2 * margin x).
	maxHeight := maxWidthAndHeight - (2 * margin y).

	self extent x * self extent y > maxArea
		ifTrue: [ self scale: (maxArea / (self extent x * self extent y)) sqrt * self cameraScale ].
	self extent x > maxWidth
		ifTrue: [ self scale: maxWidth / self extent x * self cameraScale ].
	self extent y > maxHeight
		ifTrue: [ self scale: maxHeight / self extent y * self cameraScale ]
]

{ #category : #settings }
OPTRCanvasExporter >> whole [
	"Setting applied immediately.
	Changes extent to include whole canvas, otherwise it is cropped to original camera or to size set by #extent:"

	self
		centered;
		extent: self cameraScale * canvas encompassingRectangle extent
]

{ #category : #settings }
OPTRCanvasExporter >> withoutFixedShapes [
	"Irreversible setting applied immediately.
	Removes shapes with fixed position (based on position in window/morph, not canvas)"

	canvas camera doWithoutCallbacks: [ canvas fixedShapes do: [ :shape | shape doWithoutCallbacks: [ shape remove ] ] ]
]
