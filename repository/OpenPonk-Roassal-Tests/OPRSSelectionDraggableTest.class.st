"
Verifies OPRSSelectionDraggable inner shapes providers, line control point translation, and alignment snapping during drag events.
"
Class {
	#name : 'OPRSSelectionDraggableTest',
	#superclass : 'TestCase',
	#instVars : [
		'canvas',
		'containerShape1',
		'containerShape2',
		'innerShape1',
		'innerShape2'
	],
	#category : 'OpenPonk-Roassal-Tests-Interactions',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Interactions'
}

{ #category : 'running' }
OPRSSelectionDraggableTest >> setUp [
	super setUp.
	canvas := RSCanvas new.
	canvas @ OPRSSelectableCanvas.
	containerShape1 := RSBox new
		extent: 100 @ 100;
		translateTo: 100 @ 100;
		yourself.
	innerShape1 := RSBox new
		extent: 20 @ 20;
		translateTo: 100 @ 100;
		yourself.
	containerShape2 := RSBox new
		extent: 100 @ 100;
		translateTo: 300 @ 100;
		yourself.
	innerShape2 := RSBox new
		extent: 20 @ 20;
		translateTo: 300 @ 100;
		yourself.
	canvas
		add: containerShape1;
		add: innerShape1;
		add: containerShape2;
		add: innerShape2.
	containerShape1 @ OPRSSelectionDraggable thatAlsoDragsContainedShapes.
	innerShape1 @ OPRSSelectionDraggable thatDoesNotDragAnyInnerShapes.
	containerShape2 @ OPRSSelectionDraggable thatAlsoDragsContainedShapes.
	innerShape2 @ OPRSSelectionDraggable thatDoesNotDragAnyInnerShapes
]

{ #category : 'running' }
OPRSSelectionDraggableTest >> tearDown [
	canvas := nil.
	containerShape1 := nil.
	containerShape2 := nil.
	innerShape1 := nil.
	innerShape2 := nil.
	super tearDown
]

{ #category : 'tests' }
OPRSSelectionDraggableTest >> testDraggingSelectedContainerDragsInnerShapesOfAllSelectedContainers [
	| dragInteraction draggedNodes |
	canvas propertyAt: #selectedShapes put: { containerShape1 . containerShape2 }.

	containerShape1 announce: (RSMouseDragStart new
		shape: containerShape1;
		canvas: canvas;
		position: containerShape1 position;
		yourself).

	dragInteraction := containerShape1 propertyAt: OPRSSelectionDraggable.
	draggedNodes := dragInteraction instVarNamed: #draggedNodes.

	self
		assertCollection: draggedNodes
		includesAll: { containerShape1 . containerShape2 . innerShape1 . innerShape2 }
]

{ #category : 'tests' }
OPRSSelectionDraggableTest >> testInnerShapesProvidersAndDragTranslation [
	| customInteraction line |
	self
		deny: OPRSSelectionDraggable wantsUniqueInstance
		description: 'OPRSSelectionDraggable should not use a unique shared instance'.
	line := RSPolyline new
		from: containerShape1;
		to: innerShape1;
		controlPoints: { 100 @ 100 . 110 @ 110 . 100 @ 100 };
		yourself.
	canvas add: line.
	canvas propertyAt: #selectedShapes put: { containerShape1 }.
	containerShape1 announce: (RSMouseDragStart new
		shape: containerShape1;
		canvas: canvas;
		position: containerShape1 position;
		yourself).
	containerShape1 announce: (RSMouseDragging new
		shape: containerShape1;
		canvas: canvas;
		step: 15 @ 10;
		yourself).
	self
		assert: containerShape1 position x > 100
		description: 'Dragged container shape should move along X axis'.
	self
		assert: innerShape1 position x > 100
		description: 'Inner shape inside dragged container should move with container'.
	containerShape1 announce: (RSMouseDragEnd new
		shape: containerShape1;
		canvas: canvas;
		position: containerShape1 position;
		yourself).
	customInteraction := OPRSSelectionDraggable new
		dragAlsoShapesProvidedByBlock: [ :shape | { innerShape2 } ];
		yourself.
	self
		assertCollection: (customInteraction shapesToDragInside: containerShape2)
		hasSameElements: { innerShape2 }
]

{ #category : 'tests' }
OPRSSelectionDraggableTest >> testRectangleDragAlignmentLinesAndRectangleExtensions [
	| hLine vLine bestH r1 r2 hCandidates vCandidates |
	hLine := OPRectangleDragAlignmentHorizontalLine
		dragged: 10 @ 20
		compared: 50 @ 25.
	self assert: hLine dragged equals: 10 @ 20.
	self assert: hLine compared equals: 50 @ 25.
	self assert: hLine adaptation2dOffset equals: 5.
	self assert: hLine adaptationDistance equals: 5.
	self assert: hLine adaptationOffset equals: 0 @ 5.
	self assert: hLine draggedAdapted equals: 10 @ 25.
	self assert: hLine resultingDistance equals: 40.
	self assert: hLine normalized equals: 0 @ -1.

	vLine := OPRectangleDragAlignmentVerticalLine
		dragged: 10 @ 20
		compared: 14 @ 80.
	self assert: vLine adaptation2dOffset equals: 4.
	self assert: vLine adaptationDistance equals: 4.
	self assert: vLine adaptationOffset equals: 4 @ 0.
	self assert: vLine draggedAdapted equals: 14 @ 20.
	self assert: vLine resultingDistance equals: 60.

	hLine includeOffsetOf: vLine.
	self assert: hLine dragged equals: 14 @ 20.

	bestH := OPRectangleDragAlignmentHorizontalLine
		draggedFirst: 0 @ 10
		draggedSecond: 100 @ 10
		comparedFirst: 20 @ 12
		comparedSecond: 200 @ 12.
	self assert: bestH resultingDistance equals: 200.

	r1 := 0 @ 0 corner: 40 @ 20.
	r2 := 100 @ 5 corner: 140 @ 25.
	self assert: r1 floatCenterX equals: 20.0.
	self assert: r1 floatCenterY equals: 10.0.
	hCandidates := r1 possibleHorizontalAlignmentLinesTo: r2.
	vCandidates := r1 possibleVerticalAlignmentLinesTo: r2.
	self denyEmpty: hCandidates.
	self denyEmpty: vCandidates
]
