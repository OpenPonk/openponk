Class {
	#name : 'OPRSResizableTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests',
	#package : 'OpenPonk-Roassal',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPRSResizableTest >> testAllCornerHandles32DirectionsPreserveOppositeAnchors [
	"Verifies all 4 corner handles across diagonal and single-axis movements (16 scenarios)"
	| canvas box resizable cornerCases |
	canvas := RSCanvas new extent: 1000 @ 1000.
	box := RSBox new
		size: 200 @ 150;
		position: 300 @ 300;
		borderWidth: 6;
		borderColor: Color black;
		yourself.
	canvas add: box.
	resizable := OPRSResizable new.
	resizable onShape: box.
	resizable showHandles: (RSSelectionChangedEvent new canvas: canvas; yourself).

	cornerCases := {
		"BottomRight (anchors topLeft)"
		{ #bottomRight . (25 @ 25) . [ :b | b topLeft ] }.
		{ #bottomRight . (-25 @ -25) . [ :b | b topLeft ] }.
		{ #bottomRight . (25 @ 0) . [ :b | b topLeft ] }.
		{ #bottomRight . (0 @ 25) . [ :b | b topLeft ] }.

		"TopLeft (anchors bottomRight)"
		{ #topLeft . (-25 @ -25) . [ :b | b bottomRight ] }.
		{ #topLeft . (25 @ 25) . [ :b | b bottomRight ] }.
		{ #topLeft . (-25 @ 0) . [ :b | b bottomRight ] }.
		{ #topLeft . (0 @ -25) . [ :b | b bottomRight ] }.

		"TopRight (anchors bottomLeft)"
		{ #topRight . (25 @ -25) . [ :b | b bottomLeft ] }.
		{ #topRight . (-25 @ 25) . [ :b | b bottomLeft ] }.
		{ #topRight . (25 @ 0) . [ :b | b bottomLeft ] }.
		{ #topRight . (0 @ -25) . [ :b | b bottomLeft ] }.

		"BottomLeft (anchors topRight)"
		{ #bottomLeft . (-25 @ 25) . [ :b | b topRight ] }.
		{ #bottomLeft . (25 @ -25) . [ :b | b topRight ] }.
		{ #bottomLeft . (-25 @ 0) . [ :b | b topRight ] }.
		{ #bottomLeft . (0 @ 25) . [ :b | b topRight ] }
	}.

	cornerCases do: [ :eachCase |
		| key442 step442 anchorBlock442 initAnchor442 handle442 dragEvt442 currentAnchor442 |
		key442 := eachCase first.
		step442 := eachCase second.
		anchorBlock442 := eachCase third.

		box extent: 200 @ 150.
		box translateTo: 300 @ 300.
		resizable updateHandles: nil.

		initAnchor442 := (anchorBlock442 value: box encompassingRectangle) copy.

		handle442 := resizable handles detect: [ :h442 |
			(h442 model respondsTo: #key) and: [ h442 model key = key442 ] ].

		handle442 translateBy: step442.
		dragEvt442 := RSMouseDragging new
			shape: handle442;
			step: step442;
			position: handle442 position;
			canvas: canvas;
			yourself.
		resizable updateCurrentShape: dragEvt442.

		currentAnchor442 := anchorBlock442 value: box encompassingRectangle.
		self assert: (currentAnchor442 closeTo: initAnchor442 precision: 0.001).
	]
]

{ #category : 'tests' }
OPRSResizableTest >> testAllCornerHandlesPreserveOppositeCornerAnchor [
	"Verifies that all 4 corner handles strictly preserve the opposite diagonal corner anchor"
	| canvas box resizable cornerTestCases |
	canvas := RSCanvas new extent: 1000 @ 1000.
	box := RSBox new
		size: 200 @ 150;
		position: 300 @ 300;
		borderWidth: 6;
		borderColor: Color black;
		yourself.
	canvas add: box.
	resizable := OPRSResizable new.
	resizable onShape: box.
	resizable showHandles: (RSSelectionChangedEvent new canvas: canvas; yourself).

	cornerTestCases := {
		{ #bottomRight . (20 @ 20) . [ :b | b topLeft ] }.
		{ #bottomRight . (-20 @ -20) . [ :b | b topLeft ] }.
		{ #topLeft . (-20 @ -20) . [ :b | b bottomRight ] }.
		{ #topLeft . (20 @ 20) . [ :b | b bottomRight ] }.
		{ #topRight . (20 @ -20) . [ :b | b bottomLeft ] }.
		{ #topRight . (-20 @ 20) . [ :b | b bottomLeft ] }.
		{ #bottomLeft . (-20 @ 20) . [ :b | b topRight ] }.
		{ #bottomLeft . (20 @ -20) . [ :b | b topRight ] }
	}.

	cornerTestCases do: [ :eachTestCase |
		| handleKey stepVector anchorExtractor initialAnchor targetHandle draggingEvent currentAnchor |
		handleKey := eachTestCase first.
		stepVector := eachTestCase second.
		anchorExtractor := eachTestCase third.

		box extent: 200 @ 150.
		box translateTo: 300 @ 300.
		resizable updateHandles: nil.

		initialAnchor := (anchorExtractor value: box encompassingRectangle) copy.

		targetHandle := resizable handles detect: [ :eachHandle |
			(eachHandle model respondsTo: #key) and: [ eachHandle model key = handleKey ] ].

		targetHandle translateBy: stepVector.
		draggingEvent := RSMouseDragging new
			shape: targetHandle;
			step: stepVector;
			position: targetHandle position;
			canvas: canvas;
			yourself.
		resizable updateCurrentShape: draggingEvent.

		currentAnchor := anchorExtractor value: box encompassingRectangle.
		self assert: (currentAnchor closeTo: initialAnchor precision: 0.001).
	]
]

{ #category : 'tests' }
OPRSResizableTest >> testAllEdgeHandles32DirectionsPreserveAnchorsAndOrthogonalInvariants [
	"Verifies all 4 edge handles across all 4 directions (16 scenarios): axial expansion/contraction and tangent invariance"
	| canvas box resizable edgeCases |
	canvas := RSCanvas new extent: 1000 @ 1000.
	box := RSBox new
		size: 200 @ 150;
		position: 300 @ 300;
		borderWidth: 6;
		borderColor: Color black;
		yourself.
	canvas add: box.
	resizable := OPRSResizable new.
	resizable onShape: box.
	resizable showHandles: (RSSelectionChangedEvent new canvas: canvas; yourself).

	edgeCases := {
		"handleKey . stepVector . isTangent . anchorCheckBlock"
		"Bottom handle"
		{ #bottomCenter . (0 @ 30) . false . [ :b | box encompassingRectangle top closeTo: b top precision: 0.001 ] }.
		{ #bottomCenter . (0 @ -30) . false . [ :b | box encompassingRectangle top closeTo: b top precision: 0.001 ] }.
		{ #bottomCenter . (30 @ 0) . true . [ :b | box encompassingRectangle = b ] }.
		{ #bottomCenter . (-30 @ 0) . true . [ :b | box encompassingRectangle = b ] }.

		"Top handle"
		{ #topCenter . (0 @ -30) . false . [ :b | box encompassingRectangle bottom closeTo: b bottom precision: 0.001 ] }.
		{ #topCenter . (0 @ 30) . false . [ :b | box encompassingRectangle bottom closeTo: b bottom precision: 0.001 ] }.
		{ #topCenter . (30 @ 0) . true . [ :b | box encompassingRectangle = b ] }.
		{ #topCenter . (-30 @ 0) . true . [ :b | box encompassingRectangle = b ] }.

		"Right handle"
		{ #rightCenter . (30 @ 0) . false . [ :b | box encompassingRectangle left closeTo: b left precision: 0.001 ] }.
		{ #rightCenter . (-30 @ 0) . false . [ :b | box encompassingRectangle left closeTo: b left precision: 0.001 ] }.
		{ #rightCenter . (0 @ 30) . true . [ :b | box encompassingRectangle = b ] }.
		{ #rightCenter . (0 @ -30) . true . [ :b | box encompassingRectangle = b ] }.

		"Left handle"
		{ #leftCenter . (-30 @ 0) . false . [ :b | box encompassingRectangle right closeTo: b right precision: 0.001 ] }.
		{ #leftCenter . (30 @ 0) . false . [ :b | box encompassingRectangle right closeTo: b right precision: 0.001 ] }.
		{ #leftCenter . (0 @ 30) . true . [ :b | box encompassingRectangle = b ] }.
		{ #leftCenter . (0 @ -30) . true . [ :b | box encompassingRectangle = b ] }
	}.

	edgeCases do: [ :eachCase |
		| key441 step441 isTangent441 checkBlock441 initBounds441 initWidth441 initHeight441 handle441 dragEvt441 |
		key441 := eachCase first.
		step441 := eachCase second.
		isTangent441 := eachCase third.
		checkBlock441 := eachCase fourth.

		box extent: 200 @ 150.
		box translateTo: 300 @ 300.
		resizable updateHandles: nil.

		initBounds441 := box encompassingRectangle copy.
		initWidth441 := box width.
		initHeight441 := box height.

		handle441 := resizable handles detect: [ :h441 |
			(h441 model respondsTo: #key) and: [ h441 model key = key441 ] ].

		handle441 translateBy: step441.
		dragEvt441 := RSMouseDragging new
			shape: handle441;
			step: step441;
			position: handle441 position;
			canvas: canvas;
			yourself.
		resizable updateCurrentShape: dragEvt441.

		self assert: (checkBlock441 value: initBounds441).
		isTangent441
			ifTrue: [
				self assert: box width closeTo: initWidth441 precision: 0.001.
				self assert: box height closeTo: initHeight441 precision: 0.001 ]
			ifFalse: [
				(step441 x = 0)
					ifTrue: [ self assert: box width closeTo: initWidth441 precision: 0.001 ]
					ifFalse: [ self assert: box height closeTo: initHeight441 precision: 0.001 ] ].
	]
]

{ #category : 'tests' }
OPRSResizableTest >> testAllEdgeHandlesPreserveOppositeEdgeAndOrthogonalExtent [
	"Verifies that all 4 edge center handles anchor the opposite edge and preserve orthogonal extent in all directions"
	| canvas box resizable edgeTestCases |
	canvas := RSCanvas new extent: 1000 @ 1000.
	box := RSBox new
		size: 200 @ 150;
		position: 300 @ 300;
		borderWidth: 6;
		borderColor: Color black;
		yourself.
	canvas add: box.
	resizable := OPRSResizable new.
	resizable onShape: box.
	resizable showHandles: (RSSelectionChangedEvent new canvas: canvas; yourself).

	edgeTestCases := {
		{ #bottomCenter . (0 @ 25) . [ :initialBounds | box encompassingRectangle top closeTo: initialBounds top precision: 0.001 ] . [ :initialWidth | box width closeTo: initialWidth precision: 0.001 ] }.
		{ #bottomCenter . (0 @ -25) . [ :initialBounds | box encompassingRectangle top closeTo: initialBounds top precision: 0.001 ] . [ :initialWidth | box width closeTo: initialWidth precision: 0.001 ] }.
		{ #topCenter . (0 @ -25) . [ :initialBounds | box encompassingRectangle bottom closeTo: initialBounds bottom precision: 0.001 ] . [ :initialWidth | box width closeTo: initialWidth precision: 0.001 ] }.
		{ #topCenter . (0 @ 25) . [ :initialBounds | box encompassingRectangle bottom closeTo: initialBounds bottom precision: 0.001 ] . [ :initialWidth | box width closeTo: initialWidth precision: 0.001 ] }.
		{ #rightCenter . (25 @ 0) . [ :initialBounds | box encompassingRectangle left closeTo: initialBounds left precision: 0.001 ] . [ :initialHeight | box height closeTo: initialHeight precision: 0.001 ] }.
		{ #rightCenter . (-25 @ 0) . [ :initialBounds | box encompassingRectangle left closeTo: initialBounds left precision: 0.001 ] . [ :initialHeight | box height closeTo: initialHeight precision: 0.001 ] }.
		{ #leftCenter . (-25 @ 0) . [ :initialBounds | box encompassingRectangle right closeTo: initialBounds right precision: 0.001 ] . [ :initialHeight | box height closeTo: initialHeight precision: 0.001 ] }.
		{ #leftCenter . (25 @ 0) . [ :initialBounds | box encompassingRectangle right closeTo: initialBounds right precision: 0.001 ] . [ :initialHeight | box height closeTo: initialHeight precision: 0.001 ] }
	}.

	edgeTestCases do: [ :eachTestCase |
		| handleKey stepVector anchorCheck orthogonalCheck initialBounds initialWidth initialHeight targetHandle draggingEvent |
		handleKey := eachTestCase first.
		stepVector := eachTestCase second.
		anchorCheck := eachTestCase third.
		orthogonalCheck := eachTestCase fourth.

		box extent: 200 @ 150.
		box translateTo: 300 @ 300.
		resizable updateHandles: nil.

		initialBounds := box encompassingRectangle copy.
		initialWidth := box width.
		initialHeight := box height.

		targetHandle := resizable handles detect: [ :eachHandle |
			(eachHandle model respondsTo: #key) and: [ eachHandle model key = handleKey ] ].

		targetHandle translateBy: stepVector.
		draggingEvent := RSMouseDragging new
			shape: targetHandle;
			step: stepVector;
			position: targetHandle position;
			canvas: canvas;
			yourself.
		resizable updateCurrentShape: draggingEvent.

		self assert: (anchorCheck value: initialBounds).
		(stepVector x = 0)
			ifTrue: [ self assert: (orthogonalCheck value: initialWidth) ]
			ifFalse: [ self assert: (orthogonalCheck value: initialHeight) ].
	]
]

{ #category : 'tests' }
OPRSResizableTest >> testBottomCenterHandleDragDoesNotShrinkShapeOnHorizontalMovement [
	| canvas box resizable handle startHeight draggingEvent |
	canvas := RSCanvas new extent: 1000 @ 1000.
	box := RSBox new
		size: 800 @ 600;
		position: 0 @ 0;
		borderWidth: 6;
		borderColor: Color gray;
		yourself.
	canvas add: box.
	resizable := OPRSResizable new.
	resizable onShape: box.
	resizable showHandles: (RSSelectionChangedEvent new canvas: canvas; yourself).

	handle := resizable handles detect: [ :eachHandle571 |
		(eachHandle571 model respondsTo: #key) and: [ eachHandle571 model key = #bottomCenter ] ].

	startHeight := box height.
	handle translateBy: 50 @ 0.
	draggingEvent := RSMouseDragging new
		shape: handle;
		step: 50 @ 0;
		position: handle position;
		canvas: canvas;
		yourself.
	resizable updateCurrentShape: draggingEvent.

	self assert: box height equals: startHeight
]

{ #category : 'tests' }
OPRSResizableTest >> testBottomCenterHandleDragPreservesTopEdgeAnchor [
	"Verifies that dragging bottomCenter handle strictly preserves the top edge coordinate and does not alter width"
	| canvas box resizable handle initialTop initialLeft initialWidth draggingEvent |
	canvas := RSCanvas new extent: 1000 @ 1000.
	box := RSBox new
		size: 200 @ 150;
		position: 200 @ 200;
		borderWidth: 6;
		borderColor: Color black;
		yourself.
	canvas add: box.
	resizable := OPRSResizable new.
	resizable onShape: box.
	resizable showHandles: (RSSelectionChangedEvent new canvas: canvas; yourself).

	handle := resizable handles detect: [ :eachHandle |
		(eachHandle model respondsTo: #key) and: [ eachHandle model key = #bottomCenter ] ].

	initialTop := box position y - (box height / 2).
	initialLeft := box position x - (box width / 2).
	initialWidth := box width.

	handle translateBy: 0 @ 20.
	draggingEvent := RSMouseDragging new
		shape: handle;
		step: 0 @ 20;
		position: handle position;
		canvas: canvas;
		yourself.
	resizable updateCurrentShape: draggingEvent.

	self assert: (box position y - (box height / 2)) closeTo: initialTop precision: 0.001.
	self assert: (box position x - (box width / 2)) closeTo: initialLeft precision: 0.001.
	self assert: box width closeTo: initialWidth precision: 0.001
]

{ #category : 'tests' }
OPRSResizableTest >> testRightCenterHandleDragPreservesLeftAndTopEdgeAnchors [
	"Verifies that dragging rightCenter handle strictly preserves left, top, and bottom edge coordinates without vertical growth"
	| canvas box resizable handle initialTop initialLeft initialHeight draggingEvent |
	canvas := RSCanvas new extent: 1000 @ 1000.
	box := RSBox new
		size: 200 @ 150;
		position: 200 @ 200;
		borderWidth: 6;
		borderColor: Color black;
		yourself.
	canvas add: box.
	resizable := OPRSResizable new.
	resizable onShape: box.
	resizable showHandles: (RSSelectionChangedEvent new canvas: canvas; yourself).

	handle := resizable handles detect: [ :eachHandle |
		(eachHandle model respondsTo: #key) and: [ eachHandle model key = #rightCenter ] ].

	initialTop := box position y - (box height / 2).
	initialLeft := box position x - (box width / 2).
	initialHeight := box height.

	handle translateBy: 25 @ 0.
	draggingEvent := RSMouseDragging new
		shape: handle;
		step: 25 @ 0;
		position: handle position;
		canvas: canvas;
		yourself.
	resizable updateCurrentShape: draggingEvent.

	self assert: (box position x - (box width / 2)) closeTo: initialLeft precision: 0.001.
	self assert: (box position y - (box height / 2)) closeTo: initialTop precision: 0.001.
	self assert: box height closeTo: initialHeight precision: 0.001
]
