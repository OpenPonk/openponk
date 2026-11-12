Class {
	#name : 'OPHeadlessCanvasPresenter',
	#superclass : 'Object',
	#instVars : [
		'canvas',
		'diagramController'
	],
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPHeadlessCanvasPresenter >> attachController: aDiagramController [
	(diagramController := aDiagramController) canvasPresenter: self
]

{ #category : 'accessing' }
OPHeadlessCanvasPresenter >> canvas [
	canvas ifNil: [ self canvas: RSCanvas new ].
	^ canvas
]

{ #category : 'accessing' }
OPHeadlessCanvasPresenter >> canvas: aCanvas [
	canvas := aCanvas.
	self initializeCanvas: canvas.
	^ canvas
]

{ #category : 'accessing' }
OPHeadlessCanvasPresenter >> currentCanvas [
	^ canvas
]

{ #category : 'accessing' }
OPHeadlessCanvasPresenter >> diagramController [
	^ diagramController
]

{ #category : 'accessing' }
OPHeadlessCanvasPresenter >> diagramController: aDiagramController [
	diagramController := aDiagramController
]

{ #category : 'initialization' }
OPHeadlessCanvasPresenter >> initialize [
	super initialize.
	self canvas: RSCanvas new
]

{ #category : 'initialization' }
OPHeadlessCanvasPresenter >> initializeCanvas: aCanvas [
	aCanvas @ OPRSSelectableCanvas.
	(aCanvas propertyAt: OPRSSelectableCanvas)
		when: OPRSSelectionEndEvent
		do: [ :evt |
			self
				selectedShapes: evt selectedShapes
				onPosition: evt originalEvent position ]
		for: self
]

{ #category : 'actions' }
OPHeadlessCanvasPresenter >> selectedShapes: shapes onPosition: aPosition [
	diagramController ifNotNil: [ diagramController selectedShapes: shapes onPosition: aPosition ]
]

{ #category : 'actions' }
OPHeadlessCanvasPresenter >> zoomToFit [
	self canvas shapes
		ifEmpty: [ self canvas camera scale: 1 ]
		ifNotEmpty: [ self canvas zoomToFit ]
]
