"
Unit tests verifying undo and redo mechanics for diagram geometry commands, specifically OPChangeBoundsCommand, OPModifyEdgeWaypointsCommand, and composite transactional moves.
"
Class {
	#name : 'OPDiagramGeometryCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'undoManager',
		'canvas',
		'node',
		'nodeBounds'
	],
	#category : 'OpenPonk-Core-Tests-DiagramElements',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'running' }
OPDiagramGeometryCommandTest >> setUp [
	super setUp.
	undoManager := OPUndoManager new.
	canvas := RSCanvas new.
	nodeBounds := OPNodeBounds withPosition: 100 @ 100 extent: 80 @ 50.
	node := OPTestBoundNode new.
	node bounds: nodeBounds.
	node renderIn: canvas
]

{ #category : 'tests' }
OPDiagramGeometryCommandTest >> testChangeAnchoredBoundsCommandExecuteUndoRedoWithAnchorConstraint [

	| fromShape toShape line anchorConstraint oldBounds newBounds command |
	fromShape := RSBox new
		             size: 20 @ 20;
		             position: 0 @ 0;
		             yourself.
	toShape := RSBox new
		           size: 20 @ 20;
		           position: 200 @ 0;
		           yourself.
	line := RSLine new
		        from: fromShape;
		        to: toShape;
		        yourself.
	canvas
		add: fromShape;
		add: toShape;
		add: line.
	anchorConstraint := OPRSAnchorConstraint new
		                    positionReference: (OPRSAnchorConstraintBalanceReference balance: 0.25);
		                    distanceToLine: 10;
		                    yourself.
	anchorConstraint stick: node roassalShape on: line.

	oldBounds := node bounds copy.
	newBounds := OPNodeBounds withPosition: 150 @ 30 extent: node bounds extent.
	command := OPChangeAnchoredBoundsCommand element: node oldBounds: oldBounds newBounds: newBounds.
	command
		oldBalance: 0.25
		newBalance: 0.75
		oldDistanceToLine: 10
		newDistanceToLine: 25.

	undoManager execute: command.
	self assert: anchorConstraint balance equals: 0.75.
	self assert: anchorConstraint distanceToLine equals: 25.

	undoManager undo.
	self assert: anchorConstraint balance equals: 0.25.
	self assert: anchorConstraint distanceToLine equals: 10.

	undoManager redo.
	self assert: anchorConstraint balance equals: 0.75.
	self assert: anchorConstraint distanceToLine equals: 25
]

{ #category : 'tests' }
OPDiagramGeometryCommandTest >> testChangeAnchoredBoundsCommandWithoutAnchorConstraint [

	| oldBounds newBounds command |
	oldBounds := node bounds copy.
	newBounds := OPNodeBounds withPosition: 140 @ 160 extent: node bounds extent.
	command := OPChangeAnchoredBoundsCommand element: node oldBounds: oldBounds newBounds: newBounds.
	command
		oldBalance: 0.2
		newBalance: 0.8
		oldDistanceToLine: 5
		newDistanceToLine: 15.

	undoManager execute: command.
	self assert: node position equals: 140 @ 160.

	undoManager undo.
	self assert: node position equals: 100 @ 100
]

{ #category : 'tests' }
OPDiagramGeometryCommandTest >> testChangeBoundsCommandMoveExecuteAndUndo [
	| oldBounds newBounds command initialPos newPos |
	initialPos := 100 @ 100.
	newPos := 150 @ 180.
	oldBounds := OPNodeBounds withPosition: initialPos extent: 80 @ 50.
	newBounds := OPNodeBounds withPosition: newPos extent: 80 @ 50.
	
	command := OPChangeBoundsCommand
		element: node
		oldBounds: oldBounds
		newBounds: newBounds.
		
	undoManager execute: command.
	self assert: node position equals: newPos.
	self assert: node roassalShape position equals: newPos.
	
	undoManager undo.
	self assert: node position equals: initialPos.
	self assert: node roassalShape position equals: initialPos.
	
	undoManager redo.
	self assert: node position equals: newPos.
	self assert: node roassalShape position equals: newPos
]

{ #category : 'tests' }
OPDiagramGeometryCommandTest >> testChangeBoundsCommandResizeExecuteAndUndo [
	| oldBounds newBounds command initialExtent newExtent initialPos newPos |
	initialPos := 100 @ 100.
	initialExtent := 80 @ 50.
	newPos := 110 @ 115.
	newExtent := 120 @ 90.
	
	oldBounds := OPNodeBounds withPosition: initialPos extent: initialExtent.
	newBounds := OPNodeBounds withPosition: newPos extent: newExtent.
	
	command := OPChangeBoundsCommand
		element: node
		oldBounds: oldBounds
		newBounds: newBounds.
		
	undoManager execute: command.
	self assert: node bounds extent equals: newExtent.
	self assert: node bounds position equals: newPos.
	self assert: node roassalShape extent equals: newExtent.
	self assert: node roassalShape position equals: newPos.
	
	undoManager undo.
	self assert: node bounds extent equals: initialExtent.
	self assert: node bounds position equals: initialPos.
	self assert: node roassalShape extent equals: initialExtent.
	self assert: node roassalShape position equals: initialPos.
	
	undoManager redo.
	self assert: node bounds extent equals: newExtent.
	self assert: node bounds position equals: newPos.
	self assert: node roassalShape extent equals: newExtent.
	self assert: node roassalShape position equals: newPos
]

{ #category : 'tests' }
OPDiagramGeometryCommandTest >> testModifyEdgeWaypointsCommandExecuteAndUndo [
	| edge oldPoints newPoints command |
	edge := OPEdge new.
	edge waypoints: { 0@0 . 50@50 . 100@100 }.
	
	oldPoints := { 0@0 . 50@50 . 100@100 }.
	newPoints := { 0@0 . 50@80 . 80@80 . 100@100 }.
	
	command := OPModifyEdgeWaypointsCommand
		edge: edge
		oldWaypoints: oldPoints
		newWaypoints: newPoints.
		
	undoManager execute: command.
	self assert: edge waypoints equals: newPoints.
	
	undoManager undo.
	self assert: edge waypoints equals: oldPoints.
	
	undoManager redo.
	self assert: edge waypoints equals: newPoints
]

{ #category : 'tests' }
OPDiagramGeometryCommandTest >> testModifyEdgeWaypointsCommandOnRenderedEdgeWithoutControlPoints [

	| targetNode edge oldPoints newPoints command |
	targetNode := OPTestBoundNode new.
	targetNode bounds: (OPNodeBounds withPosition: 300 @ 100 extent: 80 @ 50).
	targetNode renderIn: canvas.
	edge := OPTestEdge new.
	edge source: node.
	edge target: targetNode.
	oldPoints := {
		             (100 @ 100).
		             (150 @ 100).
		             (300 @ 100) }.
	newPoints := {
		             (100 @ 100).
		             (150 @ 180).
		             (250 @ 180).
		             (300 @ 100) }.
	edge waypoints: oldPoints copy.
	edge renderIn: canvas.

	command := OPModifyEdgeWaypointsCommand edge: edge oldWaypoints: oldPoints newWaypoints: newPoints.

	undoManager execute: command.
	self assert: edge waypoints equals: newPoints.

	undoManager undo.
	self assert: edge waypoints equals: oldPoints.

	undoManager redo.
	self assert: edge waypoints equals: newPoints
]

{ #category : 'tests' }
OPDiagramGeometryCommandTest >> testMultiNodeMoveInTransaction [
	| node2 bounds2 oldBounds1 newBounds1 oldBounds2 newBounds2 |
	bounds2 := OPNodeBounds withPosition: 200 @ 200 extent: 60 @ 40.
	node2 := OPTestBoundNode new.
	node2 bounds: bounds2.
	node2 renderIn: canvas.
	
	oldBounds1 := node bounds copy.
	newBounds1 := OPNodeBounds withPosition: 120 @ 120 extent: node bounds extent.
	oldBounds2 := node2 bounds copy.
	newBounds2 := OPNodeBounds withPosition: 220 @ 220 extent: node2 bounds extent.
	
	undoManager inTransaction: [
		undoManager execute: (OPChangeBoundsCommand element: node oldBounds: oldBounds1 newBounds: newBounds1).
		undoManager execute: (OPChangeBoundsCommand element: node2 oldBounds: oldBounds2 newBounds: newBounds2) ].
		
	self assert: node position equals: 120 @ 120.
	self assert: node2 position equals: 220 @ 220.
	
	undoManager undo.
	self assert: node position equals: 100 @ 100.
	self assert: node2 position equals: 200 @ 200.
	
	undoManager redo.
	self assert: node position equals: 120 @ 120.
	self assert: node2 position equals: 220 @ 220
]
