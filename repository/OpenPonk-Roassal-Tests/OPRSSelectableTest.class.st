Class {
	#name : 'OPRSSelectableTest',
	#superclass : 'TestCase',
	#instVars : [
		'canvas',
		'box1',
		'box2'
	],
	#category : 'OpenPonk-Roassal-Tests-Interactions',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Interactions'
}

{ #category : 'running' }
OPRSSelectableTest >> setUp [
	super setUp.
	canvas := RSCanvas new.
	box1 := RSBox new size: 40; position: 0 @ 0; yourself.
	box2 := RSBox new size: 40; position: 100 @ 100; yourself.
	canvas add: box1; add: box2
]

{ #category : 'tests' }
OPRSSelectableTest >> testClickWithoutSelectableCanvasSignalsError [
	| selectable |
	selectable := OPRSSelectable highlightBorderColorBlue.
	box1 @ selectable.
	self
		should: [ selectable fakeClicked: box1 ]
		raise: Error
]

{ #category : 'tests' }
OPRSSelectableTest >> testKeyNavigationCanvasInteraction [
	| interaction initialScale zoomedInScale |
	canvas createMorph.
	(canvas morph instVarNamed: #eventProcessor) lastMousePosition: 0 @ 0.
	interaction := OPRSKeyNavigationCanvasInteraction new.
	interaction configuration shouldAnimateZoom: false.
	canvas @ interaction.
	initialScale := canvas camera scale.
	interaction processKeyDown: (RSKeyDown new canvas: canvas; keyName: #I; yourself).
	self assert: canvas camera scale closeTo: initialScale.
	interaction processKeyDown: (RSKeyDown new canvas: canvas; keyName: #O; yourself).
	self assert: canvas camera scale closeTo: initialScale.
	interaction processKeyDown: (RSKeyDown new canvas: canvas; keyName: #PLUS; yourself).
	zoomedInScale := canvas camera scale.
	self
		assert: zoomedInScale > initialScale
		description: 'PLUS key should zoom in and increase camera scale'.
	interaction processKeyDown: (RSKeyDown new canvas: canvas; keyName: #MINUS; yourself).
	self
		assert: canvas camera scale < zoomedInScale
		description: 'MINUS key should zoom out and decrease camera scale'
]

{ #category : 'tests' }
OPRSSelectableTest >> testSelectableAndSelectableCanvasInteraction [
	| selectableCanvas selectable1 selectable2 selectable3 box3 adornmentIcon baseShapeCount |
	selectableCanvas := OPRSSelectableCanvas new.
	canvas @ selectableCanvas.
	self assert: selectableCanvas color equals: (Color black alpha: 0.2).
	self assert: selectableCanvas defaultBox color equals: (Color black alpha: 0.2).
	self assert: selectableCanvas boxStartEvent equals: RSMouseLeftDragStart.
	self assert: selectableCanvas dragStartEvent equals: RSMouseRightDragStart.

	selectable1 := OPRSSelectable highlightBorderColorBlue.
	adornmentIcon := RSBox new size: 10; yourself.
	selectable2 := OPRSSelectable highlightAdornments: [ :builder |
		builder addIconShape: adornmentIcon action: [ ] ].
	selectable3 := OPRSSelectable highlightColorBlue.
	box3 := RSBox new size: 30; color: Color white; yourself.
	canvas add: box3.
	self assert: selectable1 propertyKey equals: #selectedShapes.

	box1 @ selectable1.
	box2 @ selectable2.
	box3 @ selectable3.

	selectable1 fakeClicked: box1.
	self assertCollection: selectableCanvas selectedShapes asArray equals: { box1 }.

	selectable1 announceHighlight: box1 source: canvas.
	self assert: box1 border color equals: Color blue.
	selectable1 announceUnHightlight: box1 source: canvas.

	baseShapeCount := canvas shapes size.
	selectable2 announceHighlight: box2 source: canvas.
	self
		assert: canvas shapes size > baseShapeCount
		description: 'Highlighting with highlightAdornments: should add adornment shape to canvas'.
	selectable2 announceUnHightlight: box2 source: canvas.
	self assert: canvas shapes size equals: baseShapeCount.

	selectable3 announceHighlight: box3 source: canvas.
	self assert: box3 color equals: Color blue.
	selectable3 announceUnHightlight: box3 source: canvas.
	self assert: box3 color equals: Color white.

	selectable1 deselect: box1.
	self assertEmpty: selectableCanvas selectedShapes.

	selectableCanvas disableMultiselect.
	selectableCanvas
		selectShapes: (RSGroup with: box1 with: box2)
		byEvent: (RSMouseLeftClick new canvas: canvas; shape: box1; yourself).
	self assertEmpty: selectableCanvas selectedShapes.

	selectableCanvas enableMultiselect.
	selectableCanvas
		selectShapes: (RSGroup with: box1 with: box2)
		byEvent: (RSMouseLeftClick new canvas: canvas; shape: box1; yourself).
	self assertCollection: selectableCanvas selectedShapes asArray equals: { box1 . box2 }
]
