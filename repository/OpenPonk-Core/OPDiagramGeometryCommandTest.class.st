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
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'as yet unclassified' }
OPDiagramGeometryCommandTest >> setUp [
	super setUp.
	undoManager := OPUndoManager new.
	canvas := RSCanvas new.
	nodeBounds := OPNodeBounds withPosition: 100 @ 100 extent: 80 @ 50.
	node := OPTestBoundNode new.
	node bounds: nodeBounds.
	node renderIn: canvas
]

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
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
