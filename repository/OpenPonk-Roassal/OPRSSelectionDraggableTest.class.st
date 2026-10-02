"
Verifies multi-selection dragging behavior for visual containers and their nested shapes.

Ensures that moving a selection containing multiple container shapes properly translates the inner shapes belonging to all selected containers.
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
	#category : 'OpenPonk-Roassal-Tests',
	#package : 'OpenPonk-Roassal',
	#tag : 'Tests'
}

{ #category : 'running' }
OPRSSelectionDraggableTest >> setUp [
	super setUp.
	canvas := RSCanvas new.
	containerShape1 := RSBox new size: 200; position: 100 @ 100; yourself.
	containerShape2 := RSBox new size: 200; position: 400 @ 100; yourself.
	innerShape1 := RSBox new size: 30; position: 100 @ 100; yourself.
	innerShape2 := RSBox new size: 30; position: 400 @ 100; yourself.
	canvas addAll: { containerShape1 . containerShape2 . innerShape1 . innerShape2 }.

	containerShape1 @ (OPRSSelectionDraggable thatAlsoDragsShapesProvidedByBlock: [ { innerShape1 } ]).
	containerShape2 @ (OPRSSelectionDraggable thatAlsoDragsShapesProvidedByBlock: [ { innerShape2 } ]).
	innerShape1 @ OPRSSelectionDraggable new.
	innerShape2 @ OPRSSelectionDraggable new
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
