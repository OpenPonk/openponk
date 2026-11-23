"
Verifies shape selection, canvas elastic-box selection, and keyboard navigation interactions.
"
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
OPRSSelectableTest >> testClickMetaClickDeselectAndHighlightGuards [

	| selectableCanvas selectable1 selectable2 unattachedBox |
	selectableCanvas := OPRSSelectableCanvas new.
	canvas @ selectableCanvas.
	selectable1 := OPRSSelectable highlightBorderColorBlue.
	selectable2 := OPRSSelectable highlightBorderColorBlue.
	box1 @ selectable1.
	box2 @ selectable2.

	"Direct RSMouseLeftClick on shape triggers onShape: handler"
	box1 announce: (RSMouseLeftClick new
			 canvas: canvas;
			 shape: box1;
			 position: box1 position;
			 yourself).
	self assertCollection: selectableCanvas selectedShapes asArray equals: { box1 }.

	"Meta-click adds box2 to selection"
	box2 announce: (RSMouseLeftClick new
			 canvas: canvas;
			 shape: box2;
			 position: box2 position;
			 controlKeyPressed: true;
			 commandKeyPressed: true;
			 yourself).
	self assertCollection: selectableCanvas selectedShapes asArray hasSameElements: {
			box1.
			box2 }.

	"Second meta-click removes box2 from selection"
	box2 announce: (RSMouseLeftClick new
			 canvas: canvas;
			 shape: box2;
			 position: box2 position;
			 controlKeyPressed: true;
			 commandKeyPressed: true;
			 yourself).
	self assertCollection: selectableCanvas selectedShapes asArray equals: { box1 }.

	"Click on canvas selects canvas"
	canvas announce: (RSMouseLeftClick new
			 canvas: canvas;
			 shape: canvas;
			 position: 200 @ 200;
			 yourself).
	self assertCollection: selectableCanvas selectedShapes asArray equals: { canvas }.

	"Guards for unattached shape and shape without OPRSSelectable property"
	unattachedBox := RSBox new
		                 size: 20;
		                 yourself.
	selectable1 deselect: unattachedBox.
	selectable1 announceHighlight: unattachedBox source: canvas.
	selectable1 announceUnHightlight: unattachedBox source: canvas.
	self assertCollection: selectableCanvas selectedShapes asArray equals: { canvas }
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
OPRSSelectableTest >> testElasticBoxSelectionWhenMultiselectEnabledAndDisabled [

	| selectableCanvas |
	selectableCanvas := OPRSSelectableCanvas new.
	canvas @ selectableCanvas.
	box1 @ OPRSSelectable highlightBorderColorBlue.
	box2 @ OPRSSelectable highlightBorderColorBlue.

	"Elastic box drag with multiselect enabled"
	canvas announce: (RSMouseLeftDragStart new
			 canvas: canvas;
			 shape: canvas;
			 position: -50 @ -50;
			 yourself).
	canvas announce: (RSMouseDragging new
			 canvas: canvas;
			 shape: canvas;
			 position: 150 @ 150;
			 step: 200 @ 200;
			 yourself).
	canvas announce: (RSMouseDragEnd new
			 canvas: canvas;
			 shape: canvas;
			 position: 150 @ 150;
			 yourself).
	self assertCollection: selectableCanvas selectedShapes asArray hasSameElements: {
			box1.
			box2 }.

	"Elastic box drag with multiselect disabled ignores box start/update"
	selectableCanvas disableMultiselect.
	canvas announce: (RSMouseLeftDragStart new
			 canvas: canvas;
			 shape: canvas;
			 position: -50 @ -50;
			 yourself).
	canvas announce: (RSMouseDragging new
			 canvas: canvas;
			 shape: canvas;
			 position: 10 @ 10;
			 step: 60 @ 60;
			 yourself).
	self assertCollection: selectableCanvas selectedShapes asArray hasSameElements: {
			box1.
			box2 }
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
	interaction processKeyDown: (RSKeyDown new
			 canvas: canvas;
			 keyName: #I;
			 yourself).
	self assert: canvas camera scale closeTo: initialScale.
	interaction processKeyDown: (RSKeyDown new
			 canvas: canvas;
			 keyName: #O;
			 yourself).
	self assert: canvas camera scale closeTo: initialScale.
	interaction processKeyDown: (RSKeyDown new
			 canvas: canvas;
			 keyName: #PLUS;
			 yourself).
	zoomedInScale := canvas camera scale.
	self assert: zoomedInScale closeTo: initialScale * 1.5.
	interaction processKeyDown: (RSKeyDown new
			 canvas: canvas;
			 keyName: #MINUS;
			 yourself).
	self assert: canvas camera scale closeTo: zoomedInScale * 0.5
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
	adornmentIcon := RSBox new
		                 size: 10;
		                 yourself.
	selectable2 := OPRSSelectable highlightAdornments: [ :builder | builder addIconShape: adornmentIcon action: [ ] ].
	selectable3 := OPRSSelectable highlightColorBlue.
	box3 := RSBox new
		        size: 30;
		        color: Color white;
		        yourself.
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
	self assert: canvas shapes size equals: baseShapeCount + 2.
	selectable2 announceUnHightlight: box2 source: canvas.
	self assert: canvas shapes size equals: baseShapeCount.

	selectable3 announceHighlight: box3 source: canvas.
	self assert: box3 color equals: Color blue.
	selectable3 announceUnHightlight: box3 source: canvas.
	self assert: box3 color equals: Color white.

	selectable1 deselect: box1.
	self assertEmpty: selectableCanvas selectedShapes.

	selectableCanvas disableMultiselect.
	selectableCanvas selectShapes: (RSGroup with: box1 with: box2) byEvent: (RSMouseLeftClick new
			 canvas: canvas;
			 shape: box1;
			 yourself).
	self assertEmpty: selectableCanvas selectedShapes.

	selectableCanvas enableMultiselect.
	selectableCanvas selectShapes: (RSGroup with: box1 with: box2) byEvent: (RSMouseLeftClick new
			 canvas: canvas;
			 shape: box1;
			 yourself).
	self assertCollection: selectableCanvas selectedShapes asArray equals: {
			box1.
			box2 }
]
