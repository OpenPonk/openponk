Class {
	#name : 'OPRSSelectionDraggableBorderTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests-Interactions',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Interactions'
}

{ #category : 'tests' }
OPRSSelectionDraggableBorderTest >> testDragBoxesCreationUpdatingEventForwardingAndRemoval [
	| canvas shape deferredShape border deferredBorder dragBoxes topBox clickedShape |
	canvas := RSCanvas new.
	canvas @ OPRSSelectableCanvas.

	shape := RSBox new
		model: #mainModel;
		extent: 100 @ 60;
		translateTo: 50 @ 50;
		yourself.
	canvas add: shape.
	border := OPRSSelectionDraggableBorder new.
	self assert: border dragBoxWidth equals: 12.
	shape @ border.

	dragBoxes := border instVarNamed: #dragBoxes.
	self assert: dragBoxes size equals: 4.
	self
		assert: (dragBoxes values allSatisfy: [ :each | each isInACanvas and: [ each model = #mainModel ] ])
		description: 'All 4 drag boxes should be added to canvas and share main shape model'.

	deferredShape := RSBox new extent: 40 @ 8; yourself.
	deferredBorder := OPRSSelectionDraggableBorder new.
	deferredShape @ deferredBorder.
	self
		deny: ((deferredBorder instVarNamed: #dragBoxes) values anySatisfy: #isInACanvas)
		description: 'Drag boxes for unrendered shape must not be in canvas before RSShapeAddedEvent'.
	canvas add: deferredShape.
	self
		assert: ((deferredBorder instVarNamed: #dragBoxes) values allSatisfy: #isInACanvas)
		description: 'Adding shape to canvas should trigger RSShapeAddedEvent and add its drag boxes'.

	shape extent: 120 @ 80.
	shape translateTo: 200 @ 100.
	topBox := dragBoxes at: #top.
	self assert: topBox width equals: 120 + 12.
	self assert: topBox position equals: shape encompassingRectangle topCenter.
	self assert: (dragBoxes at: #bottom) position equals: shape encompassingRectangle bottomCenter.
	self assert: (dragBoxes at: #left) position equals: shape encompassingRectangle leftCenter.
	self assert: (dragBoxes at: #right) position equals: shape encompassingRectangle rightCenter.

	clickedShape := nil.
	shape when: RSMouseClick do: [ :evt | clickedShape := evt shape ] for: self.
	topBox announce: (RSMouseClick new shape: topBox; canvas: canvas; yourself).
	self assert: clickedShape identicalTo: shape.

	canvas propertyAt: #selectedShapes put: { shape }.
	topBox announce: (RSMouseDragStart new
		shape: topBox;
		canvas: canvas;
		position: topBox position;
		yourself).
	topBox announce: (RSMouseDragging new
		shape: topBox;
		canvas: canvas;
		step: 20 @ 15;
		yourself).
	topBox announce: (RSMouseDragEnd new
		shape: topBox;
		canvas: canvas;
		position: topBox position;
		yourself).
	self assert: shape position equals: 220 @ 115.

	shape remove.
	self
		deny: (dragBoxes values anySatisfy: #isInACanvas)
		description: 'Removing main shape from canvas should remove all drag boxes'
]
