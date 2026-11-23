"
Tests shape resizing interactions, boundary constraints, and visual feedback handles in Roassal canvas presenters.
"
Class {
	#name : 'OPRSResizableTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests-Interactions',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Interactions'
}

{ #category : 'private' }
OPRSResizableTest >> dragHandle: aHandle by: aStep on: aCanvas using: aResizable [

	| draggingEvent |
	aHandle translateBy: aStep.
	draggingEvent := RSMouseDragging new
		                 shape: aHandle;
		                 step: aStep;
		                 position: aHandle position;
		                 canvas: aCanvas;
		                 yourself.
	aResizable updateCurrentShape: draggingEvent
]

{ #category : 'private' }
OPRSResizableTest >> handleNamed: aKey on: aResizable [

	^ aResizable handles allButFirst detect: [ :eachHandle | eachHandle model key = aKey ]
]

{ #category : 'private' }
OPRSResizableTest >> newResizableBoxOn: aCanvas [

	| box resizable |
	box := RSBox new
		       size: 200 @ 150;
		       position: 300 @ 300;
		       borderWidth: 6;
		       borderColor: Color black;
		       yourself.
	aCanvas add: box.
	resizable := OPRSResizable new.
	resizable onShape: box.
	resizable showHandles: (RSSelectionChangedEvent new
			 canvas: aCanvas;
			 yourself).
	^ box -> resizable
]

{ #category : 'tests' }
OPRSResizableTest >> testAllCornerHandles32DirectionsPreserveOppositeAnchors [

	| canvas pair box resizable cornerCases |
	canvas := RSCanvas new extent: 1000 @ 1000.
	pair := self newResizableBoxOn: canvas.
	box := pair key.
	resizable := pair value.

	cornerCases := {
		               {
			               #bottomRight.
			               (25 @ 25).
			               [ :bounds | bounds topLeft ] }.
		               {
			               #bottomRight.
			               (-25 @ -25).
			               [ :bounds | bounds topLeft ] }.
		               {
			               #bottomRight.
			               (25 @ 0).
			               [ :bounds | bounds topLeft ] }.
		               {
			               #bottomRight.
			               (0 @ 25).
			               [ :bounds | bounds topLeft ] }.
		               {
			               #topLeft.
			               (-25 @ -25).
			               [ :bounds | bounds bottomRight ] }.
		               {
			               #topLeft.
			               (25 @ 25).
			               [ :bounds | bounds bottomRight ] }.
		               {
			               #topLeft.
			               (-25 @ 0).
			               [ :bounds | bounds bottomRight ] }.
		               {
			               #topLeft.
			               (0 @ -25).
			               [ :bounds | bounds bottomRight ] }.
		               {
			               #topRight.
			               (25 @ -25).
			               [ :bounds | bounds bottomLeft ] }.
		               {
			               #topRight.
			               (-25 @ 25).
			               [ :bounds | bounds bottomLeft ] }.
		               {
			               #topRight.
			               (25 @ 0).
			               [ :bounds | bounds bottomLeft ] }.
		               {
			               #topRight.
			               (0 @ -25).
			               [ :bounds | bounds bottomLeft ] }.
		               {
			               #bottomLeft.
			               (-25 @ 25).
			               [ :bounds | bounds topRight ] }.
		               {
			               #bottomLeft.
			               (25 @ -25).
			               [ :bounds | bounds topRight ] }.
		               {
			               #bottomLeft.
			               (-25 @ 0).
			               [ :bounds | bounds topRight ] }.
		               {
			               #bottomLeft.
			               (0 @ 25).
			               [ :bounds | bounds topRight ] } }.

	cornerCases do: [ :eachCase |
			| handleKey stepVector anchorExtractor initialAnchor targetHandle currentAnchor |
			handleKey := eachCase first.
			stepVector := eachCase second.
			anchorExtractor := eachCase third.
			box extent: 200 @ 150.
			box translateTo: 300 @ 300.
			resizable updateHandles: nil.
			initialAnchor := (anchorExtractor value: box encompassingRectangle) copy.
			targetHandle := self handleNamed: handleKey on: resizable.
			self
				dragHandle: targetHandle
				by: stepVector
				on: canvas
				using: resizable.
			currentAnchor := anchorExtractor value: box encompassingRectangle.
			self
				assert: (currentAnchor closeTo: initialAnchor precision: 0.001)
				description: 'Corner handle drag must preserve opposite corner anchor' ]
]

{ #category : 'tests' }
OPRSResizableTest >> testAllEdgeHandles32DirectionsPreserveAnchorsAndOrthogonalInvariants [

	| canvas pair box resizable edgeCases |
	canvas := RSCanvas new extent: 1000 @ 1000.
	pair := self newResizableBoxOn: canvas.
	box := pair key.
	resizable := pair value.

	edgeCases := {
		             {
			             #bottomCenter.
			             (0 @ 30).
			             [ :bounds | box encompassingRectangle top closeTo: bounds top precision: 0.001 ] }.
		             {
			             #bottomCenter.
			             (0 @ -30).
			             [ :bounds | box encompassingRectangle top closeTo: bounds top precision: 0.001 ] }.
		             {
			             #bottomCenter.
			             (30 @ 0).
			             [ :bounds | box encompassingRectangle = bounds ] }.
		             {
			             #bottomCenter.
			             (-30 @ 0).
			             [ :bounds | box encompassingRectangle = bounds ] }.
		             {
			             #topCenter.
			             (0 @ -30).
			             [ :bounds | box encompassingRectangle bottom closeTo: bounds bottom precision: 0.001 ] }.
		             {
			             #topCenter.
			             (0 @ 30).
			             [ :bounds | box encompassingRectangle bottom closeTo: bounds bottom precision: 0.001 ] }.
		             {
			             #topCenter.
			             (30 @ 0).
			             [ :bounds | box encompassingRectangle = bounds ] }.
		             {
			             #topCenter.
			             (-30 @ 0).
			             [ :bounds | box encompassingRectangle = bounds ] }.
		             {
			             #rightCenter.
			             (30 @ 0).
			             [ :bounds | box encompassingRectangle left closeTo: bounds left precision: 0.001 ] }.
		             {
			             #rightCenter.
			             (-30 @ 0).
			             [ :bounds | box encompassingRectangle left closeTo: bounds left precision: 0.001 ] }.
		             {
			             #rightCenter.
			             (0 @ 30).
			             [ :bounds | box encompassingRectangle = bounds ] }.
		             {
			             #rightCenter.
			             (0 @ -30).
			             [ :bounds | box encompassingRectangle = bounds ] }.
		             {
			             #leftCenter.
			             (-30 @ 0).
			             [ :bounds | box encompassingRectangle right closeTo: bounds right precision: 0.001 ] }.
		             {
			             #leftCenter.
			             (30 @ 0).
			             [ :bounds | box encompassingRectangle right closeTo: bounds right precision: 0.001 ] }.
		             {
			             #leftCenter.
			             (0 @ 30).
			             [ :bounds | box encompassingRectangle = bounds ] }.
		             {
			             #leftCenter.
			             (0 @ -30).
			             [ :bounds | box encompassingRectangle = bounds ] } }.

	edgeCases do: [ :eachCase |
			| handleKey stepVector anchorCheck initialBounds targetHandle |
			handleKey := eachCase first.
			stepVector := eachCase second.
			anchorCheck := eachCase third.
			box extent: 200 @ 150.
			box translateTo: 300 @ 300.
			resizable updateHandles: nil.
			initialBounds := box encompassingRectangle copy.
			targetHandle := self handleNamed: handleKey on: resizable.
			self
				dragHandle: targetHandle
				by: stepVector
				on: canvas
				using: resizable.
			self
				assert: (anchorCheck value: initialBounds)
				description: 'Edge handle drag must preserve opposite edge anchor and orthogonal invariant' ]
]

{ #category : 'tests' }
OPRSResizableTest >> testBottomCenterHandleDragDoesNotShrinkShapeOnHorizontalMovement [

	| canvas box resizable handle startHeight |
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
	resizable showHandles: (RSSelectionChangedEvent new
			 canvas: canvas;
			 yourself).
	handle := self handleNamed: #bottomCenter on: resizable.
	startHeight := box height.
	self
		dragHandle: handle
		by: 50 @ 0
		on: canvas
		using: resizable.
	self assert: box height equals: startHeight
]

{ #category : 'tests' }
OPRSResizableTest >> testBottomCenterHandleDragPreservesTopEdgeAnchor [

	| canvas pair box resizable handle initialTop initialLeft initialWidth |
	canvas := RSCanvas new extent: 1000 @ 1000.
	pair := self newResizableBoxOn: canvas.
	box := pair key.
	resizable := pair value.
	handle := self handleNamed: #bottomCenter on: resizable.
	initialTop := box position y - (box height / 2).
	initialLeft := box position x - (box width / 2).
	initialWidth := box width.
	self
		dragHandle: handle
		by: 0 @ 20
		on: canvas
		using: resizable.
	self assert: box position y - (box height / 2) closeTo: initialTop precision: 0.001.
	self assert: box position x - (box width / 2) closeTo: initialLeft precision: 0.001.
	self assert: box width closeTo: initialWidth precision: 0.001
]

{ #category : 'tests' }
OPRSResizableTest >> testDeselectRemovesHandlesAndSubsequentDragDoesNotRestoreThem [

	| canvas box resizable dragStartEvt dragEndEvt |
	canvas := RSCanvas new.
	canvas @ OPRSSelectableCanvas.

	box := RSBox new
		       size: 60;
		       color: Color white;
		       borderColor: Color black;
		       yourself.
	canvas add: box.
	box @ OPRSSelectable.
	box @ OPRSResizable.
	box @ OPRSSelectionDraggable.

	resizable := box propertyAt: OPRSResizable.

	"1. Select shape and verify handles are displayed"
	resizable showHandles: (OPRSSelectionEndEvent new
			 canvas: canvas;
			 selectedShapes: { box };
			 yourself).
	self assert: resizable handles size equals: 9.

	"2. Deselect shape"
	resizable removeHandles: (OPRSSelectionEndEvent new
			 canvas: canvas;
			 selectedShapes: #(  );
			 yourself).
	self assert: resizable handles identicalTo: nil.

	"3. Drag the unselected shape"
	dragStartEvt := RSMouseDragStart new
		                shape: box;
		                canvas: canvas;
		                position: 10 @ 10;
		                yourself.
	box announce: dragStartEvt.
	dragEndEvt := RSMouseDragEnd new
		              shape: box;
		              canvas: canvas;
		              position: 30 @ 30;
		              yourself.
	box announce: dragEndEvt.

	"4. Assert handles did NOT reappear on unselected shape"
	self assert: resizable handles identicalTo: nil
]

{ #category : 'tests' }
OPRSResizableTest >> testHandleDragStartAndEndAnnouncesResizedEventAndHandlesGuards [

	| canvas pair box resizable handle announcedEvents event initialExtent |
	canvas := RSCanvas new extent: 1000 @ 1000.
	pair := self newResizableBoxOn: canvas.
	box := pair key.
	resizable := pair value.
	announcedEvents := OrderedCollection new.
	canvas when: OPRSShapeResizedEvent do: [ :each | announcedEvents add: each ] for: self.
	handle := self handleNamed: #bottomRight on: resizable.
	initialExtent := box extent copy.

	"Interactive resize announces OPRSShapeResizedEvent"
	handle announce: (RSMouseDragStart new
			 shape: handle;
			 canvas: canvas;
			 position: handle position;
			 yourself).
	self
		dragHandle: handle
		by: 20 @ 10
		on: canvas
		using: resizable.
	handle announce: (RSMouseDragEnd new
			 shape: handle;
			 canvas: canvas;
			 position: handle position;
			 yourself).
	self assert: announcedEvents size equals: 1.
	event := announcedEvents first.
	self assert: event shape identicalTo: box.
	self assert: event oldExtent equals: initialExtent.
	self assert: event newExtent equals: initialExtent + (20 @ 10).

	"Fallback when shape is nil but currentShape is set, and anEvent is nil"
	resizable instVarNamed: #shape put: nil.
	resizable handleDragStarted: nil.
	box extent: 240 @ 180.
	resizable instVarNamed: #shape put: nil.
	resizable handleDragEnded: nil.
	self assert: announcedEvents size equals: 2.

	"Early return when both shape and currentShape are nil"
	resizable instVarNamed: #shape put: nil.
	resizable instVarNamed: #currentShape put: nil.
	resizable handleDragEnded: nil.
	self assert: announcedEvents size equals: 2
]

{ #category : 'tests' }
OPRSResizableTest >> testMultiStepDraggingPreservesMovedEdgeDeltaAndOppositeAnchor [

	| canvas pair box resizable scenarios |
	canvas := RSCanvas new extent: 1000 @ 1000.
	pair := self newResizableBoxOn: canvas.
	box := pair key.
	resizable := pair value.
	scenarios := {
		             {
			             #rightCenter.
			             (1 @ 0).
			             [ :rectangle | rectangle right ].
			             [ :rectangle | rectangle left ].
			             10 }.
		             {
			             #leftCenter.
			             (-1 @ 0).
			             [ :rectangle | rectangle left ].
			             [ :rectangle | rectangle right ].
			             -10 }.
		             {
			             #bottomCenter.
			             (0 @ 1).
			             [ :rectangle | rectangle bottom ].
			             [ :rectangle | rectangle top ].
			             10 }.
		             {
			             #topCenter.
			             (0 @ -1).
			             [ :rectangle | rectangle top ].
			             [ :rectangle | rectangle bottom ].
			             -10 }.
		             {
			             #bottomRight.
			             (1 @ 1).
			             [ :rectangle | rectangle bottomRight ].
			             [ :rectangle | rectangle topLeft ].
			             (10 @ 10) } }.
	scenarios do: [ :eachScenario |
			| handleKey stepVector movedExtractor oppositeExtractor expectedDelta initialBounds targetHandle initialOpposite initialMoved |
			handleKey := eachScenario first.
			stepVector := eachScenario second.
			movedExtractor := eachScenario third.
			oppositeExtractor := eachScenario fourth.
			expectedDelta := eachScenario fifth.
			box extent: 200 @ 150.
			box translateTo: 300 @ 300.
			resizable updateHandles: nil.
			initialBounds := box encompassingRectangle copy.
			initialOpposite := (oppositeExtractor value: initialBounds) copy.
			initialMoved := (movedExtractor value: initialBounds) copy.
			targetHandle := self handleNamed: handleKey on: resizable.
			10 timesRepeat: [
					self
						dragHandle: targetHandle
						by: stepVector
						on: canvas
						using: resizable ].
			self
				assert: ((oppositeExtractor value: box encompassingRectangle) closeTo: initialOpposite precision: 0.001)
				description: 'Multi-step resize must preserve opposite anchor coordinate'.
			self
				assert: ((movedExtractor value: box encompassingRectangle) closeTo: initialMoved + expectedDelta precision: 0.001)
				description: 'Multi-step resize must accumulate exact moved edge delta' ]
]

{ #category : 'tests' }
OPRSResizableTest >> testOnShapeIgnoresNonNodeConnectsDeferredShapeAndCleansUpOnRemoval [

	| canvas line box resizable |
	canvas := RSCanvas new.
	canvas @ OPRSSelectableCanvas.
	line := RSLine new.
	line @ OPRSResizable new.
	self deny: (line hasProperty: OPRSResizable) description: 'Non-node shapes must be ignored by OPRSResizable'.

	box := RSBox new
		       size: 60;
		       translateTo: 100 @ 100;
		       yourself.
	resizable := OPRSResizable new.
	box @ resizable.
	canvas add: box.
	resizable showHandles: (OPRSSelectionEndEvent new
			 canvas: canvas;
			 selectedShapes: { box };
			 yourself).
	self assert: resizable handles size equals: 9.

	"Remove properties before shape removal to exercise ifAbsent: paths as well"
	box removePropertyAt: OPRSResizable ifAbsent: [ ].
	box removePropertyAt: resizable key ifAbsent: [ ].
	box remove.
	self assert: resizable handles identicalTo: nil
]

{ #category : 'tests' }
OPRSResizableTest >> testRemoveHandlesUpdateCurrentShapeAndUpdateHandlesGuards [

	| canvas pair box resizable |
	canvas := RSCanvas new extent: 1000 @ 1000.
	pair := self newResizableBoxOn: canvas.
	box := pair key.
	resizable := pair value.

	"updateHandles: with currentShape nil falls back to shape"
	resizable instVarNamed: #currentShape put: nil.
	resizable updateHandles: nil.
	self assert: resizable handles size equals: 9.

	"updateHandles: with handles size < 2 returns early"
	resizable instVarNamed: #handles put: { resizable handles first }.
	resizable updateHandles: nil.

	"removeHandles: nil uses shape canvas fallback and clears handles"
	resizable removeHandles: nil.
	self assert: resizable handles identicalTo: nil.

	"updateHandles: with handles nil returns early"
	resizable updateHandles: nil.

	"updateCurrentShape: and updateHandles: with currentShape and shape nil return early"
	resizable instVarNamed: #currentShape put: nil.
	resizable instVarNamed: #shape put: nil.
	resizable updateCurrentShape: nil.
	resizable updateHandles: nil.
	self assert: resizable handles identicalTo: nil
]

{ #category : 'tests' }
OPRSResizableTest >> testRightCenterHandleDragPreservesLeftAndTopEdgeAnchors [

	| canvas pair box resizable handle initialTop initialLeft initialHeight |
	canvas := RSCanvas new extent: 1000 @ 1000.
	pair := self newResizableBoxOn: canvas.
	box := pair key.
	resizable := pair value.
	handle := self handleNamed: #rightCenter on: resizable.
	initialTop := box position y - (box height / 2).
	initialLeft := box position x - (box width / 2).
	initialHeight := box height.
	self
		dragHandle: handle
		by: 25 @ 0
		on: canvas
		using: resizable.
	self assert: box position x - (box width / 2) closeTo: initialLeft precision: 0.001.
	self assert: box position y - (box height / 2) closeTo: initialTop precision: 0.001.
	self assert: box height closeTo: initialHeight precision: 0.001
]
