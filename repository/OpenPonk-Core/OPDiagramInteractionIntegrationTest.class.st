"
Integration tests verifying that user interactions on Roassal canvas (drag-and-drop, multi-selection move, resizing) correctly create and execute reversible commands in OPUndoManager.
"
Class {
	#name : 'OPDiagramInteractionIntegrationTest',
	#superclass : 'TestCase',
	#instVars : [
		'diagramController',
		'canvas',
		'undoManager',
		'node1',
		'node2',
		'edge'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPDiagramInteractionIntegrationTest >> setUp [
	| presenter project projectController |
	super setUp.
	project := OPProject new.
	projectController := OPProjectController forProject: project.
	undoManager := OPUndoManager new.
	projectController instVarNamed: #undoManager put: undoManager.
	diagramController := OPDiagramController new.
	projectController addDiagramController: diagramController.

	presenter := OPCanvasPresenter new.
	canvas := presenter canvas.
	canvas propertyAt: #diagramController put: diagramController.
	presenter attachController: diagramController.

	node1 := OPTestBoundNode new.
	node1 bounds: (OPNodeBounds withPosition: 100 @ 100 extent: 80 @ 50).
	node1 renderIn: canvas.

	node2 := OPTestBoundNode new.
	node2 bounds: (OPNodeBounds withPosition: 300 @ 100 extent: 80 @ 50).
	node2 renderIn: canvas.

	edge := OPTestEdge new.
	edge
		source: node1;
		target: node2.
	edge renderIn: canvas
]

{ #category : 'tests' }
OPDiagramInteractionIntegrationTest >> testCreateNodeCommandClearsControllerReferenceAfterExecution [
	| testDiagramController project containerModel diagram entityController command initialPosition createdModel restoredController projectController |
	project := OPProject new.
	containerModel := OPTestContainerModel new.
	project addModel: containerModel.

	diagram := OPOpenPonkDiagram forModelElement: containerModel.
	project addDiagram: diagram.
	diagram renderIn: canvas.

	projectController := OPProjectController forProject: project.
	projectController instVarNamed: #undoManager put: undoManager.

	testDiagramController := OPTestDiagramController new.
	projectController addDiagramController: testDiagramController.
	testDiagramController canvasPresenter: (OPCanvasPresenter new canvas: canvas; yourself).
	testDiagramController diagramElement: diagram.
	testDiagramController model: containerModel.

	initialPosition := 180 @ 140.
	entityController := OPTestEntityController new.
	command := OPCreateNodeCommand
		controller: entityController
		parentModel: containerModel
		diagramController: testDiagramController
		position: initialPosition.

	self assert: command controller isNotNil description: 'Controller must be provided prior to execution'.
	self assert: command diagramController isNotNil description: 'DiagramController must be provided prior to execution'.

	undoManager inTransaction: [
		undoManager execute: command ].

	self assert: command controller isNil
		description: 'Command must nullify transient controller reference immediately after initial execution'.
	self assert: command diagramController isNil
		description: 'Command must nullify transient diagram controller reference immediately after initial execution'.

	createdModel := command model.
	undoManager undo.
	self deny: entityController isRendered description: 'Initial controller must be unrendered after undo'.

	undoManager redo.
	restoredController := testDiagramController controllerForModel: createdModel.
	self assert: restoredController isRendered description: 'Diagram must construct fresh controller on redo'.
	self assert: restoredController diagramElement bounds position equals: initialPosition
]

{ #category : 'tests' }
OPDiagramInteractionIntegrationTest >> testDragWaypointToCollinearRemovesPointAndRecordsUndoCommand [
	| controlPointsInteraction creatorHandle waypointHandle initialMidpointPosition bentPosition straightPosition dragEndEvent |
	controlPointsInteraction := edge roassalShape propertyAt: OPRSDraggableControlPoints.
	controlPointsInteraction showHandles.
	creatorHandle := controlPointsInteraction midpointHandles first.
	initialMidpointPosition := creatorHandle shape position copy.

	"Step 1: Promote midpoint by click to establish a 3-point line"
	creatorHandle clickBox announce: (RSMouseLeftClick new
		shape: creatorHandle clickBox;
		canvas: canvas;
		position: initialMidpointPosition;
		yourself).

	waypointHandle := controlPointsInteraction handles first.
	bentPosition := initialMidpointPosition + (0 @ 60).

	"Step 2: Drag handle to bent position"
	waypointHandle clickBox announce: (RSMouseDragStart new
		shape: waypointHandle clickBox;
		canvas: canvas;
		position: initialMidpointPosition;
		yourself).
	waypointHandle clickBox position: bentPosition.
	waypointHandle shape position: bentPosition.
	waypointHandle changedPositionBy: (RSPositionChangedEvent new
		shape: waypointHandle shape;
		oldPosition: initialMidpointPosition;
		newPosition: bentPosition;
		yourself).
	waypointHandle onDragEnd: (RSMouseDragEnd new
		shape: waypointHandle clickBox;
		canvas: canvas;
		position: bentPosition;
		yourself).

	self assert: edge roassalShape controlPoints size equals: 3.
	self assert: edge waypoints size equals: 3.
	undoManager clear.

	"Step 3: Drag handle back onto the straight line between neighbor endpoints (collinear)"
	straightPosition := initialMidpointPosition.
	waypointHandle := controlPointsInteraction handles first.
	waypointHandle clickBox announce: (RSMouseDragStart new
		shape: waypointHandle clickBox;
		canvas: canvas;
		position: bentPosition;
		yourself).
	waypointHandle clickBox position: straightPosition.
	waypointHandle shape position: straightPosition.
	waypointHandle changedPositionBy: (RSPositionChangedEvent new
		shape: waypointHandle shape;
		oldPosition: bentPosition;
		newPosition: straightPosition;
		yourself).

	"Step 4: End drag - triggers collinear removal and waypoints changed announcement"
	dragEndEvent := RSMouseDragEnd new
		shape: waypointHandle clickBox;
		canvas: canvas;
		position: straightPosition;
		yourself.
	waypointHandle onDragEnd: dragEndEvent.

	"Step 5: Verify point removal and atomic undo command"
	self assert: edge roassalShape controlPoints size equals: 2.
	self assert: edge waypoints size equals: 2.
	self assert: undoManager canUndo.

	undoManager undo.
	self assert: edge roassalShape controlPoints size equals: 3.

	undoManager redo.
	self assert: edge roassalShape controlPoints size equals: 2
]

{ #category : 'tests' }
OPDiagramInteractionIntegrationTest >> testEdgeStraightenConnectionRecordsUndoCommand [
	| controlPointsInteraction creatorHandle controlPointHandle |
	canvas propertyAt: OPRSSelectableCanvas ifPresent: [ :selectableCanvas |
		selectableCanvas selectShapes: (RSGroup with: edge roassalShape) byEvent: (RSMouseClick new
			canvas: canvas;
			shape: canvas;
			position: 0 @ 0;
			yourself) ].
	controlPointsInteraction := edge roassalShape propertyAt: OPRSDraggableControlPoints.
	creatorHandle := controlPointsInteraction midpointHandles first.
	creatorHandle promote.
	(controlPointsInteraction midpointHandles first) promote.
	self assert: edge roassalShape controlPoints size equals: 4.
	undoManager clear.

	controlPointHandle := controlPointsInteraction handles first.
	controlPointHandle straightenConnection.

	self assert: undoManager canUndo description: 'Straightening connection must record undo command'.
	self assert: edge roassalShape controlPoints size equals: 2.
	self assert: edge waypoints size equals: 2.

	undoManager undo.
	self assert: edge roassalShape controlPoints size equals: 4.
	self assert: edge waypoints size equals: 4.

	undoManager redo.
	self assert: edge roassalShape controlPoints size equals: 2.
	self assert: edge waypoints size equals: 2
]

{ #category : 'tests' }
OPDiagramInteractionIntegrationTest >> testEdgeWaypointMoveRecordsUndoCommand [

	| cpInteraction creatorHandle cpHandle dragStartEvent dragEndEvent initialPos newPos |
	canvas propertyAt: OPRSSelectableCanvas ifPresent: [ :selCanvas |
			selCanvas selectShapes: (RSGroup with: edge roassalShape) byEvent: (RSMouseClick new
					 canvas: canvas;
					 shape: canvas;
					 position: 0 @ 0;
					 yourself) ].

	cpInteraction := edge roassalShape propertyAt: OPRSDraggableControlPoints.
	creatorHandle := cpInteraction midpointHandles first.
	creatorHandle promote.
	undoManager clear.

	cpHandle := cpInteraction handles first.
	initialPos := cpHandle shape position copy.
	newPos := initialPos + (0 @ 60).

	dragStartEvent := RSMouseDragStart new
		                  shape: cpHandle clickBox;
		                  canvas: canvas;
		                  position: initialPos;
		                  yourself.
	cpHandle clickBox announce: dragStartEvent.

	cpHandle clickBox position: newPos.
	cpHandle shape position: newPos.
	cpHandle changedPositionBy: (RSPositionChangedEvent new
			 shape: cpHandle shape;
			 oldPosition: initialPos;
			 newPosition: newPos;
			 yourself).

	dragEndEvent := RSMouseDragEnd new
		                shape: cpHandle clickBox;
		                canvas: canvas;
		                position: newPos;
		                yourself.
	cpHandle clickBox announce: dragEndEvent.

	self assert: undoManager canUndo description: 'Moving control point must record undo command'.
	self assert: (edge waypoints at: 2) equals: newPos.

	undoManager undo.
	self assert: (edge waypoints at: 2) equals: initialPos.
	self assert: (edge roassalShape controlPoints at: 2) equals: initialPos.

	undoManager redo.
	self assert: (edge waypoints at: 2) equals: newPos.
	self assert: (edge roassalShape controlPoints at: 2) equals: newPos
]

{ #category : 'tests' }
OPDiagramInteractionIntegrationTest >> testEdgeWaypointPromoteRecordsUndoCommand [

	| cpInteraction creatorHandle |
	canvas propertyAt: OPRSSelectableCanvas ifPresent: [ :selCanvas |
			selCanvas selectShapes: (RSGroup with: edge roassalShape) byEvent: (RSMouseClick new
					 canvas: canvas;
					 shape: canvas;
					 position: 0 @ 0;
					 yourself) ].

	cpInteraction := edge roassalShape propertyAt: OPRSDraggableControlPoints.
	self assert: cpInteraction isNotNil.
	self assert: edge roassalShape controlPoints size equals: 2.

	creatorHandle := cpInteraction midpointHandles first.
	creatorHandle promote.

	self assert: undoManager canUndo description: 'Promoting midpoint must record undo command'.
	self assert: edge roassalShape controlPoints size equals: 3.
	self assert: edge waypoints size equals: 3.

	undoManager undo.
	self assert: edge roassalShape controlPoints size equals: 2.
	self assert: edge waypoints size equals: 2.

	undoManager redo.
	self assert: edge roassalShape controlPoints size equals: 3.
	self assert: edge waypoints size equals: 3
]

{ #category : 'tests' }
OPDiagramInteractionIntegrationTest >> testEdgeWaypointRemovePointRecordsUndoCommand [
	| controlPointsInteraction creatorHandle controlPointHandle |
	canvas propertyAt: OPRSSelectableCanvas ifPresent: [ :selectableCanvas |
		selectableCanvas selectShapes: (RSGroup with: edge roassalShape) byEvent: (RSMouseClick new
			canvas: canvas;
			shape: canvas;
			position: 0 @ 0;
			yourself) ].
	controlPointsInteraction := edge roassalShape propertyAt: OPRSDraggableControlPoints.
	creatorHandle := controlPointsInteraction midpointHandles first.
	creatorHandle promote.
	self assert: edge roassalShape controlPoints size equals: 3.
	undoManager clear.

	controlPointHandle := controlPointsInteraction handles first.
	controlPointHandle removePoint.

	self assert: undoManager canUndo description: 'Removing control point must record undo command'.
	self assert: edge roassalShape controlPoints size equals: 2.
	self assert: edge waypoints size equals: 2.

	undoManager undo.
	self assert: edge roassalShape controlPoints size equals: 3.
	self assert: edge waypoints size equals: 3.

	undoManager redo.
	self assert: edge roassalShape controlPoints size equals: 2.
	self assert: edge waypoints size equals: 2
]

{ #category : 'as yet unclassified' }
OPDiagramInteractionIntegrationTest >> testHandlesFollowDynamicExtentExpansion [

	| resizableInteraction handle initialHandlePos newExtent expectedHandlePos basePolygon |
	canvas propertyAt: OPRSSelectableCanvas ifPresent: [ :selCanvas |
			selCanvas selectShapes: (RSGroup with: node1 roassalShape) byEvent: (RSMouseClick new
					 canvas: canvas;
					 shape: canvas;
					 position: 0 @ 0;
					 yourself) ].

	resizableInteraction := node1 roassalShape propertyAt: OPRSResizable.
	handle := (resizableInteraction instVarNamed: #handles) detect: [ :each |
		          (each model isKindOf: Association) and: [ each model key = #bottomRight ] ].
	basePolygon := (resizableInteraction instVarNamed: #handles) first.
	initialHandlePos := handle position copy.

	"Simulate external shape enlargement (e.g. BORM text edit / auto-layout)"
	newExtent := 160 @ 100.
	node1 roassalShape extent: newExtent.

	expectedHandlePos := node1 roassalShape position + (newExtent / 2).
	self assert: handle position equals: expectedHandlePos.
	self
		assert: (basePolygon encompassingRectangle extent closeTo: newExtent)
		description: 'Selection box must expand to cover the new shape extent'
]

{ #category : 'tests' }
OPDiagramInteractionIntegrationTest >> testMidpointClickCreatesUndoableCommandWhenLineModelIsDomainObject [
	| controlPointsInteraction creatorHandle domainModelAssociation edgeController |
	domainModelAssociation := Object new.
	edgeController := OPElementController new.
	edgeController instVarNamed: #diagramElement put: edge.
	diagramController addController: edgeController.
	edge roassalShape model: domainModelAssociation.

	controlPointsInteraction := edge roassalShape propertyAt: OPRSDraggableControlPoints.
	controlPointsInteraction showHandles.
	creatorHandle := controlPointsInteraction midpointHandles first.
	undoManager clear.

	creatorHandle clickBox announce: (RSMouseLeftClick new
		shape: creatorHandle clickBox;
		canvas: canvas;
		position: creatorHandle shape position;
		yourself).

	self assert: undoManager canUndo description: 'Clicking midpoint handle must record an undoable command even when line model is a domain object'.
	self assert: edge roassalShape controlPoints size equals: 3.
	self assert: edge waypoints size equals: 3.

	undoManager undo.
	self assert: edge roassalShape controlPoints size equals: 2.
	self assert: edge waypoints size equals: 2.

	undoManager redo.
	self assert: edge roassalShape controlPoints size equals: 3.
	self assert: edge waypoints size equals: 3
]

{ #category : 'tests' }
OPDiagramInteractionIntegrationTest >> testMidpointClickFollowedBySubsequentHandleDragRecordsTwoSeparateUndoCommands [
	| controlPointsInteraction creatorHandle newHandle dragStartEvent dragEndEvent initialMidpointPos movedPos |
	controlPointsInteraction := edge roassalShape propertyAt: OPRSDraggableControlPoints.
	controlPointsInteraction showHandles.
	creatorHandle := controlPointsInteraction midpointHandles first.
	initialMidpointPos := creatorHandle shape position copy.
	undoManager clear.

	"Step 1: User clicks midpoint handle"
	creatorHandle clickBox announce: (RSMouseLeftClick new
		shape: creatorHandle clickBox;
		canvas: canvas;
		position: initialMidpointPos;
		yourself).

	self assert: undoManager canUndo description: 'Clicking midpoint must record first command'.
	self assert: edge roassalShape controlPoints size equals: 3.

	"Step 2: User subsequently drags the newly created waypoint handle to a new position"
	newHandle := controlPointsInteraction handles first.
	movedPos := initialMidpointPos + (0 @ 50).

	dragStartEvent := RSMouseDragStart new
		shape: newHandle clickBox;
		canvas: canvas;
		position: initialMidpointPos;
		yourself.
	newHandle clickBox announce: dragStartEvent.

	newHandle clickBox position: movedPos.
	newHandle shape position: movedPos.
	newHandle changedPositionBy: (RSPositionChangedEvent new
		shape: newHandle shape;
		oldPosition: initialMidpointPos;
		newPosition: movedPos;
		yourself).

	dragEndEvent := RSMouseDragEnd new
		shape: newHandle clickBox;
		canvas: canvas;
		position: movedPos;
		yourself.
	newHandle onDragEnd: dragEndEvent.

	self assert: undoManager undoStack size equals: 2.

	"Step 3: First Undo must revert only the drag movement (keeping 3 waypoints)"
	undoManager undo.
	self assert: edge roassalShape controlPoints size equals: 3.
	self assert: (edge waypoints at: 2) equals: initialMidpointPos.

	"Step 4: Second Undo must revert the midpoint creation (back to straight 2 points)"
	undoManager undo.
	self assert: edge roassalShape controlPoints size equals: 2.
	self assert: edge waypoints size equals: 2
]

{ #category : 'tests' }
OPDiagramInteractionIntegrationTest >> testMidpointContinuousDragTransfersFocusAndRecordsSingleAtomicCommand [
	| controlPointsInteraction creatorHandle morphicDragEvent newHandle eventProcessor |
	controlPointsInteraction := edge roassalShape propertyAt: OPRSDraggableControlPoints.
	controlPointsInteraction showHandles.
	creatorHandle := controlPointsInteraction midpointHandles first.
	undoManager clear.

	canvas createMorph.
	eventProcessor := canvas morph instVarNamed: #eventProcessor.
	morphicDragEvent := MouseButtonEvent new
		setType: #mouseDown
		position: canvas morph bounds origin + (canvas camera fromSpaceToPixel: creatorHandle shape position)
		which: 4
		buttons: 4
		hand: HandMorph new
		stamp: 0.

	eventProcessor instVarNamed: #eventBeginingDragging put: morphicDragEvent.
	eventProcessor instVarNamed: #shapeBeingPointed put: creatorHandle clickBox.

	creatorHandle clickBox announce: (RSMouseDragStart new
		shape: creatorHandle clickBox;
		canvas: canvas;
		position: creatorHandle shape position;
		yourself).

	newHandle := controlPointsInteraction handles first.
	self assert: eventProcessor isDragging description: 'Drag must remain active in event processor after midpoint promotion'.
	self assert: (eventProcessor instVarNamed: #shapeBeingPointed) == newHandle clickBox
		description: 'Shape being dragged must seamlessly transfer to newly created handle clickBox'.

	newHandle clickBox translateBy: 0 @ 30.
	newHandle shape translateBy: 0 @ 30.
	newHandle changedPositionBy: (RSPositionChangedEvent new
		shape: newHandle shape;
		oldPosition: 200 @ 100;
		newPosition: 200 @ 130;
		yourself).

	newHandle onDragEnd: (RSMouseDragEnd new
		shape: newHandle clickBox;
		canvas: canvas;
		position: 200 @ 130;
		yourself).

	self assert: undoManager canUndo description: 'Finishing continuous drag must record an undo command'.
	self assert: edge roassalShape controlPoints size equals: 3.
	self assert: edge waypoints size equals: 3.

	undoManager undo.
	self assert: edge roassalShape controlPoints size equals: 2.
	self assert: edge waypoints size equals: 2.

	undoManager redo.
	self assert: edge roassalShape controlPoints size equals: 3.
	self assert: edge waypoints size equals: 3
]

{ #category : 'tests' }
OPDiagramInteractionIntegrationTest >> testMultiSegmentMidpointContinuousDragRecordsAtomicCommand [
	| controlPointsInteraction firstCreator firstHandle secondCreator newHandle dragStartEvent dragEndEvent initialPos movedPos originalPoints |
	controlPointsInteraction := edge roassalShape propertyAt: OPRSDraggableControlPoints.
	controlPointsInteraction showHandles.

	"Step 1: Promote first midpoint by click to establish a 3-point line"
	firstCreator := controlPointsInteraction midpointHandles first.
	firstCreator clickBox announce: (RSMouseLeftClick new
		shape: firstCreator clickBox;
		canvas: canvas;
		position: firstCreator shape position;
		yourself).

	self assert: edge roassalShape controlPoints size equals: 3.
	undoManager clear.
	originalPoints := edge roassalShape controlPoints copy.

	"Step 2: Continuously drag the second midpoint handle of the now 3-point line"
	secondCreator := controlPointsInteraction midpointHandles second.
	initialPos := secondCreator shape position copy.
	secondCreator basicPromote.

	newHandle := controlPointsInteraction handles detect: [ :eachHandle | eachHandle indexOfControlPoint = 3 ].
	movedPos := initialPos + (0 @ 40).

	dragStartEvent := RSMouseDragStart new
		shape: newHandle clickBox;
		canvas: canvas;
		position: initialPos;
		yourself.
	newHandle clickBox announce: dragStartEvent.

	newHandle clickBox position: movedPos.
	newHandle shape position: movedPos.
	newHandle changedPositionBy: (RSPositionChangedEvent new
		shape: newHandle shape;
		oldPosition: initialPos;
		newPosition: movedPos;
		yourself).

	dragEndEvent := RSMouseDragEnd new
		shape: newHandle clickBox;
		canvas: canvas;
		position: movedPos;
		yourself.
	newHandle onDragEnd: dragEndEvent.

	self assert: undoManager canUndo.
	self assert: undoManager undoStack size equals: 1.
	self assert: edge roassalShape controlPoints size equals: 4.

	"Step 3: Undo must revert back to exactly the 3-point line"
	undoManager undo.
	self assert: edge roassalShape controlPoints size equals: 3.
	self assert: edge waypoints equals: originalPoints.

	"Step 4: Redo must restore the 4-point line"
	undoManager redo.
	self assert: edge roassalShape controlPoints size equals: 4
]

{ #category : 'as yet unclassified' }
OPDiagramInteractionIntegrationTest >> testMultiSelectionDragCreatesAtomicTransaction [
	| interaction dragStartEvent dragEndEvent initialPos1 initialPos2 delta clickEvent |
	initialPos1 := 100 @ 100.
	initialPos2 := 300 @ 100.
	delta := 50 @ 50.
	
	clickEvent := RSMouseClick new
		canvas: canvas;
		shape: canvas;
		position: 0 @ 0;
		yourself.
		
	canvas propertyAt: OPRSSelectableCanvas ifPresent: [ :selCanvas |
		selCanvas
			selectShapes: (RSGroup with: node1 roassalShape with: node2 roassalShape)
			byEvent: clickEvent ].
	
	interaction := node1 roassalShape propertyAt: OPRSSelectionDraggable.
	
	dragStartEvent := RSMouseDragStart new
		shape: node1 roassalShape;
		canvas: canvas;
		position: initialPos1;
		yourself.
	interaction startDrag: dragStartEvent.
	
	node1 roassalShape translateBy: delta.
	node2 roassalShape translateBy: delta.
	
	dragEndEvent := RSMouseDragEnd new
		shape: node1 roassalShape;
		canvas: canvas;
		position: initialPos1 + delta;
		yourself.
	interaction endDrag: dragEndEvent.
	
	self assert: undoManager canUndo.
	self assert: node1 bounds position equals: initialPos1 + delta.
	self assert: node2 bounds position equals: initialPos2 + delta.
	
	undoManager undo.
	self assert: node1 bounds position equals: initialPos1.
	self assert: node2 bounds position equals: initialPos2.
	self assert: node1 roassalShape position equals: initialPos1.
	self assert: node2 roassalShape position equals: initialPos2.
	
	undoManager redo.
	self assert: node1 bounds position equals: initialPos1 + delta.
	self assert: node2 bounds position equals: initialPos2 + delta.
	self assert: node1 roassalShape position equals: initialPos1 + delta.
	self assert: node2 roassalShape position equals: initialPos2 + delta
]

{ #category : 'as yet unclassified' }
OPDiagramInteractionIntegrationTest >> testNoEventRecursionDuringInteractiveResize [
	| resizableInteraction handle dragStartEvent dragEndEvent |
	canvas propertyAt: OPRSSelectableCanvas ifPresent: [ :selCanvas |
		selCanvas
			selectShapes: (RSGroup with: node1 roassalShape)
			byEvent: (RSMouseClick new canvas: canvas; shape: canvas; position: 0 @ 0; yourself) ].
			
	resizableInteraction := node1 roassalShape propertyAt: OPRSResizable.
	handle := (resizableInteraction instVarNamed: #handles)
		detect: [ :each | (each model isKindOf: Association) and: [ each model key = #bottomRight ] ].
		
	dragStartEvent := RSMouseDragStart new
		shape: handle;
		canvas: canvas;
		position: handle position;
		yourself.
	handle announce: dragStartEvent.
	
	"Handle position changed during user drag"
	handle position: handle position + (20 @ 15).
	handle announce: (RSPositionChangedEvent new shape: handle; oldPosition: handle position - (20 @ 15); newPosition: handle position).
	
	dragEndEvent := RSMouseDragEnd new
		shape: handle;
		canvas: canvas;
		position: handle position;
		yourself.
	handle announce: dragEndEvent.
	
	self assert: undoManager canUndo description: 'Drag completed without recursion or deadlocks'
]

{ #category : 'as yet unclassified' }
OPDiagramInteractionIntegrationTest >> testNodeResizeRecordsUndoCommand [
	| resizableInteraction handle dragStartEvent dragEndEvent initialPos initialExtent newExtent newPos |
	initialPos := node1 position copy.
	initialExtent := node1 extent copy.
	
	canvas propertyAt: OPRSSelectableCanvas ifPresent: [ :selCanvas |
		selCanvas
			selectShapes: (RSGroup with: node1 roassalShape)
			byEvent: (RSMouseClick new canvas: canvas; shape: canvas; position: 0 @ 0; yourself) ].
			
	resizableInteraction := node1 roassalShape propertyAt: OPRSResizable.
	self assert: (resizableInteraction instVarNamed: #handles) isNotNil description: 'Resize handles must be rendered upon selection'.
	
	handle := (resizableInteraction instVarNamed: #handles)
		detect: [ :each | (each model isKindOf: Association) and: [ each model key = #bottomRight ] ].
		
	dragStartEvent := RSMouseDragStart new
		shape: handle;
		canvas: canvas;
		position: handle position;
		yourself.
	handle announce: dragStartEvent.
	
	newExtent := initialExtent + (40 @ 30).
	newPos := initialPos + (20 @ 15).
	node1 roassalShape extent: newExtent.
	node1 roassalShape translateTo: newPos.
	
	dragEndEvent := RSMouseDragEnd new
		shape: handle;
		canvas: canvas;
		position: handle position + (40 @ 30);
		yourself.
	handle announce: dragEndEvent.
	
	self assert: undoManager canUndo description: 'Resize must record an undo command'.
	self assert: node1 bounds extent equals: newExtent.
	self assert: node1 bounds position equals: newPos.
	self assert: node1 roassalShape extent equals: newExtent.
	self assert: node1 roassalShape position equals: newPos.
	
	undoManager undo.
	self assert: node1 bounds extent equals: initialExtent.
	self assert: node1 bounds position equals: initialPos.
	self assert: node1 roassalShape extent equals: initialExtent.
	self assert: node1 roassalShape position equals: initialPos.
	
	undoManager redo.
	self assert: node1 bounds extent equals: newExtent.
	self assert: node1 bounds position equals: newPos.
	self assert: node1 roassalShape extent equals: newExtent.
	self assert: node1 roassalShape position equals: newPos
]

{ #category : 'as yet unclassified' }
OPDiagramInteractionIntegrationTest >> testSingleNodeDragRecordsUndoCommand [
	| interaction dragStartEvent dragEndEvent initialPos newPos |
	initialPos := 100 @ 100.
	newPos := 160 @ 140.
	interaction := node1 roassalShape propertyAt: OPRSSelectionDraggable.
	
	dragStartEvent := RSMouseDragStart new
		shape: node1 roassalShape;
		canvas: canvas;
		position: initialPos;
		yourself.
	interaction startDrag: dragStartEvent.
	
	node1 roassalShape translateTo: newPos.
	
	dragEndEvent := RSMouseDragEnd new
		shape: node1 roassalShape;
		canvas: canvas;
		position: newPos;
		yourself.
	interaction endDrag: dragEndEvent.
	
	self assert: undoManager canUndo description: 'Drag must record an undo command'.
	self assert: node1 bounds position equals: newPos.
	self assert: node1 roassalShape position equals: newPos.
	
	undoManager undo.
	self assert: node1 bounds position equals: initialPos.
	self assert: node1 roassalShape position equals: initialPos.
	
	undoManager redo.
	self assert: node1 bounds position equals: newPos.
	self assert: node1 roassalShape position equals: newPos
]

{ #category : 'tests' }
OPDiagramInteractionIntegrationTest >> testUndoRedoNodeCreationPreservesBoundsAndUpdatesCanvas [
	| testDiagramController project containerModel diagram entityController command initialBounds renderedShape createdModel restoredController projectController |
	project := OPProject new.
	containerModel := OPTestContainerModel new.
	project addModel: containerModel.

	diagram := OPOpenPonkDiagram forModelElement: containerModel.
	project addDiagram: diagram.
	diagram renderIn: canvas.

	projectController := OPProjectController forProject: project.
	projectController instVarNamed: #undoManager put: undoManager.

	testDiagramController := OPTestDiagramController new.
	projectController addDiagramController: testDiagramController.
	testDiagramController canvasPresenter: (OPCanvasPresenter new canvas: canvas; yourself).
	testDiagramController diagramElement: diagram.
	testDiagramController model: containerModel.

	initialBounds := OPNodeBounds withPosition: 220 @ 180 extent: 90 @ 60.
	entityController := OPTestEntityController new.
	command := OPCreateNodeCommand
		controller: entityController
		parentModel: containerModel
		diagramController: testDiagramController
		position: initialBounds position.

	undoManager inTransaction: [
		undoManager execute: command ].

	createdModel := command model.
	renderedShape := entityController diagramElement roassalShape.
	self assert: entityController diagramElement isRendered description: 'Node must be rendered after creation'.
	self assert: (canvas shapes includes: renderedShape) description: 'Canvas shapes must include node shape after creation'.
	self assert: entityController diagramElement bounds position equals: initialBounds position.

	undoManager undo.
	self deny: entityController isRendered description: 'Initial controller must not be rendered after undo'.
	self deny: (canvas shapes includes: renderedShape) description: 'Canvas shapes must not contain node shape after undo'.

	undoManager redo.
	restoredController := testDiagramController controllerForModel: createdModel.
	self assert: restoredController isRendered description: 'Restored controller must be rendered after redo'.
	self assert: (canvas shapes includes: restoredController roassalShape) description: 'Canvas shapes must contain restored node shape after redo'.
	self assert: restoredController diagramElement bounds position equals: initialBounds position
]

{ #category : 'as yet unclassified' }
OPDiagramInteractionIntegrationTest >> testZeroDeltaDragDoesNotPolluteHistory [
	| interaction dragStartEvent dragEndEvent pos |
	pos := 100 @ 100.
	interaction := node1 roassalShape propertyAt: OPRSSelectionDraggable.
	
	dragStartEvent := RSMouseDragStart new
		shape: node1 roassalShape;
		canvas: canvas;
		position: pos;
		yourself.
	interaction startDrag: dragStartEvent.
	
	dragEndEvent := RSMouseDragEnd new
		shape: node1 roassalShape;
		canvas: canvas;
		position: pos;
		yourself.
	interaction endDrag: dragEndEvent.
	
	self deny: undoManager canUndo description: 'Zero delta drag must not record any command'
]

{ #category : 'as yet unclassified' }
OPDiagramInteractionIntegrationTest >> testZeroDeltaResizeDoesNotPolluteHistory [
	| resizableInteraction handle dragStartEvent dragEndEvent |
	canvas propertyAt: OPRSSelectableCanvas ifPresent: [ :selCanvas |
		selCanvas
			selectShapes: (RSGroup with: node1 roassalShape)
			byEvent: (RSMouseClick new canvas: canvas; shape: canvas; position: 0 @ 0; yourself) ].
			
	resizableInteraction := node1 roassalShape propertyAt: OPRSResizable.
	handle := (resizableInteraction instVarNamed: #handles)
		detect: [ :each | (each model isKindOf: Association) and: [ each model key = #bottomRight ] ].
		
	dragStartEvent := RSMouseDragStart new
		shape: handle;
		canvas: canvas;
		position: handle position;
		yourself.
	handle announce: dragStartEvent.
	
	dragEndEvent := RSMouseDragEnd new
		shape: handle;
		canvas: canvas;
		position: handle position;
		yourself.
	handle announce: dragEndEvent.
	
	self deny: undoManager canUndo description: 'Zero delta resize must not record any command'
]

{ #category : 'tests' }
OPDiagramInteractionIntegrationTest >> testZeroDeltaWaypointMoveDoesNotPolluteHistory [

	| cpInteraction creatorHandle cpHandle dragStartEvent dragEndEvent initialPos |
	canvas propertyAt: OPRSSelectableCanvas ifPresent: [ :selCanvas |
			selCanvas selectShapes: (RSGroup with: edge roassalShape) byEvent: (RSMouseClick new
					 canvas: canvas;
					 shape: canvas;
					 position: 0 @ 0;
					 yourself) ].

	cpInteraction := edge roassalShape propertyAt: OPRSDraggableControlPoints.
	creatorHandle := cpInteraction midpointHandles first.
	creatorHandle promote.
	undoManager clear.

	cpHandle := cpInteraction handles first.
	initialPos := cpHandle shape position copy.

	dragStartEvent := RSMouseDragStart new
		                  shape: cpHandle clickBox;
		                  canvas: canvas;
		                  position: initialPos;
		                  yourself.
	cpHandle clickBox announce: dragStartEvent.

	dragEndEvent := RSMouseDragEnd new
		                shape: cpHandle clickBox;
		                canvas: canvas;
		                position: initialPos;
		                yourself.
	cpHandle clickBox announce: dragEndEvent.

	self deny: undoManager canUndo description: 'Zero delta move must not pollute undo history'
]
