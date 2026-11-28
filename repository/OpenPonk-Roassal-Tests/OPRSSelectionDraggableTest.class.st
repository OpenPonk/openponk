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
OPRSSelectionDraggableTest >> testDragSnappingAlignmentLinesAndComparisonsLimit [

	| controller config targetHorizontal1 targetHorizontal2 targetVertical distantShape draggedBox |
	config := OPRSControlConfiguration new
		          dragSnapComparisonsAmount: 3;
		          dragSnapMargin: 5;
		          yourself.
	controller := RSCanvasController new
		              configuration: config;
		              yourself.
	canvas propertyAt: RSCanvasController put: controller.

	draggedBox := RSBox new
		              extent: 40 @ 40;
		              translateTo: 500 @ 500;
		              yourself.
	targetHorizontal1 := RSBox new
		                     extent: 40 @ 40;
		                     translateTo: 600 @ 502;
		                     yourself.
	targetHorizontal2 := RSBox new
		                     extent: 40 @ 40;
		                     translateTo: 660 @ 502;
		                     yourself.
	targetVertical := RSBox new
		                  extent: 40 @ 40;
		                  translateTo: 503 @ 600;
		                  yourself.
	distantShape := RSBox new
		                extent: 40 @ 40;
		                translateTo: 2000 @ 2000;
		                yourself.
	canvas
		add: draggedBox;
		add: targetHorizontal1;
		add: targetHorizontal2;
		add: targetVertical;
		add: distantShape.
	{
		draggedBox.
		targetHorizontal1.
		targetHorizontal2.
		targetVertical.
		distantShape } do: [ :each | each @ OPRSSelectionDraggable thatDoesNotDragAnyInnerShapes ].

	canvas propertyAt: #selectedShapes put: { draggedBox }.
	draggedBox announce: (RSMouseDragStart new
			 shape: draggedBox;
			 canvas: canvas;
			 position: draggedBox position;
			 yourself).
	draggedBox announce: (RSMouseDragging new
			 shape: draggedBox;
			 canvas: canvas;
			 step: 0 @ 0;
			 yourself).
	"Snapped horizontally (+2 on Y) and vertically (+3 on X) to aligned neighbors"
	self assert: draggedBox position equals: 503 @ 502.
	draggedBox announce: (RSMouseDragEnd new
			 shape: draggedBox;
			 canvas: canvas;
			 position: draggedBox position;
			 yourself)
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
OPRSSelectionDraggableTest >> testDraggingUnselectedShapeWhileAnotherShapeIsSelectedDragsOnlyUnselectedShape [

	| dragInteraction draggedNodes |
	canvas propertyAt: #selectedShapes put: { containerShape2 }.

	containerShape1 announce: (RSMouseDragStart new
			 shape: containerShape1;
			 canvas: canvas;
			 position: containerShape1 position;
			 yourself).

	dragInteraction := containerShape1 propertyAt: OPRSSelectionDraggable.
	draggedNodes := dragInteraction instVarNamed: #draggedNodes.

	self assertCollection: draggedNodes hasSameElements: {
			containerShape1.
			innerShape1 }.

	containerShape1 announce: (RSMouseDragEnd new
			 shape: containerShape1;
			 canvas: canvas;
			 position: containerShape1 position;
			 yourself)
]

{ #category : 'tests' }
OPRSSelectionDraggableTest >> testEndDragDetectsLineOnlyControlPointChangeAndSkipsUnchangedDrag [

	| line announcedEvents |
	line := RSPolyline new
		        from: containerShape1;
		        to: innerShape1;
		        controlPoints: {
				        (100 @ 100).
				        (110 @ 110).
				        (100 @ 100) };
		        yourself.
	canvas add: line.
	announcedEvents := OrderedCollection new.
	canvas when: OPRSElementsDraggedEvent do: [ :each | announcedEvents add: each ] for: self.

	canvas propertyAt: #selectedShapes put: { containerShape1 }.
	containerShape1 announce: (RSMouseDragStart new
			 shape: containerShape1;
			 canvas: canvas;
			 position: containerShape1 position;
			 yourself).
	containerShape1 announce: (RSMouseDragEnd new
			 shape: containerShape1;
			 canvas: canvas;
			 position: containerShape1 position;
			 yourself).
	self assertEmpty: announcedEvents.

	containerShape1 announce: (RSMouseDragStart new
			 shape: containerShape1;
			 canvas: canvas;
			 position: containerShape1 position;
			 yourself).
	line innerControlPoints: { (125 @ 125) }.
	containerShape1 announce: (RSMouseDragEnd new
			 shape: containerShape1;
			 canvas: canvas;
			 position: containerShape1 position;
			 yourself).
	self assert: announcedEvents size equals: 1.
	self assertCollection: announcedEvents first lines asArray equals: { line }
]

{ #category : 'tests' }
OPRSSelectionDraggableTest >> testFactoryMethodAndCustomShapesProviderDefaults [

	| defaultProvider factoryInteraction nonDraggableChild |
	defaultProvider := OPRSSelectionDraggableCustomShapesProvider new.
	self assertEmpty: (defaultProvider innerShapesFor: containerShape1).

	nonDraggableChild := RSBox new
		                     size: 10;
		                     translateTo: 100 @ 100;
		                     yourself.
	canvas add: nonDraggableChild.
	factoryInteraction := OPRSSelectionDraggable thatAlsoDragsShapesProvidedByBlock: [ :allNodes :container |
			                      {
				                      innerShape2.
				                      nonDraggableChild } ].
	self assertCollection: (factoryInteraction shapesToDragInside: containerShape2) hasSameElements: { innerShape2 }
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
		        controlPoints: {
				        (100 @ 100).
				        (110 @ 110).
				        (100 @ 100) };
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
	self assert: containerShape1 position equals: 115 @ 110.
	self assert: innerShape1 position equals: 115 @ 110.
	containerShape1 announce: (RSMouseDragEnd new
			 shape: containerShape1;
			 canvas: canvas;
			 position: containerShape1 position;
			 yourself).
	customInteraction := OPRSSelectionDraggable new
		                     dragAlsoShapesProvidedByBlock: [ :shape | { innerShape2 } ];
		                     yourself.
	self assertCollection: (customInteraction shapesToDragInside: containerShape2) hasSameElements: { innerShape2 }
]

{ #category : 'tests' }
OPRSSelectionDraggableTest >> testProcessDragAfterEndDragDoesNotRaiseError [

	| initialPosition |
	initialPosition := containerShape1 position copy.
	containerShape1 announce: (RSMouseDragStart new
			 shape: containerShape1;
			 canvas: canvas;
			 position: containerShape1 position;
			 yourself).
	containerShape1 announce: (RSMouseDragEnd new
			 shape: containerShape1;
			 canvas: canvas;
			 position: containerShape1 position;
			 yourself).
	containerShape1 announce: (RSMouseDragging new
			 shape: containerShape1;
			 canvas: canvas;
			 step: 10 @ 5;
			 yourself).
	self assert: containerShape1 position equals: initialPosition
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

{ #category : 'tests' }
OPRSSelectionDraggableTest >> testStartDragWithEmptySelectionAndAnchoredShapeCapturesInitialAnchors [

	| line anchoredBox constraint announcedEvents event |
	line := RSPolyline new
		        from: containerShape1;
		        to: containerShape2;
		        controlPoints: {
				        (100 @ 100).
				        (300 @ 100) };
		        yourself.
	anchoredBox := RSBox new
		               size: 12;
		               yourself.
	canvas
		add: line;
		add: anchoredBox.
	constraint := OPRSAnchorConstraint new
		              positionReference: (OPRSAnchorConstraintBalanceReference balance: 0.5);
		              distanceToLine: 8;
		              yourself.
	constraint stick: anchoredBox on: line.
	anchoredBox @ OPRSSelectionDraggable thatDoesNotDragAnyInnerShapes.

	announcedEvents := OrderedCollection new.
	canvas when: OPRSElementsDraggedEvent do: [ :each | announcedEvents add: each ] for: self.

	"Empty selection falls back to dragged shape"
	canvas propertyAt: #selectedShapes put: #(  ).
	anchoredBox announce: (RSMouseDragStart new
			 shape: anchoredBox;
			 canvas: canvas;
			 position: anchoredBox position;
			 yourself).
	anchoredBox announce: (RSMouseDragging new
			 shape: anchoredBox;
			 canvas: canvas;
			 step: 10 @ 5;
			 optionKeyPressed: true;
			 yourself).
	anchoredBox announce: (RSMouseDragEnd new
			 shape: anchoredBox;
			 canvas: canvas;
			 position: anchoredBox position;
			 yourself).

	self assert: announcedEvents size equals: 1.
	event := announcedEvents first.
	self assert: (event hasInitialAnchorFor: anchoredBox) description: 'Dragged anchored shape should record initial anchor state'.
	self assert: (event initialAnchorFor: anchoredBox) equals: { 0.5. 8 }
]
