"
Verifies single-shape dragging, anchor state capture, and OPRSElementsDraggedEvent announcements in OPRSDraggable.
"
Class {
	#name : 'OPRSDraggableTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests-Interactions',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Interactions'
}

{ #category : 'tests' }
OPRSDraggableTest >> testDragAnchoredShapeCapturesInitialAnchorState [

	| canvas fromBox toBox line labelBox constraint announcedEvents event |
	canvas := RSCanvas new.
	fromBox := RSBox new
		           size: 20;
		           translateTo: 0 @ 0;
		           yourself.
	toBox := RSBox new
		         size: 20;
		         translateTo: 100 @ 0;
		         yourself.
	line := RSPolyline new
		        from: fromBox;
		        to: toBox;
		        controlPoints: {
				        (0 @ 0).
				        (100 @ 0) };
		        yourself.
	labelBox := RSBox new
		            size: 10;
		            yourself.
	canvas
		add: fromBox;
		add: toBox;
		add: line;
		add: labelBox.
	constraint := OPRSAnchorConstraint new
		              positionReference: (OPRSAnchorConstraintBalanceReference balance: 0.5);
		              distanceToLine: 12;
		              yourself.
	constraint stick: labelBox on: line.
	labelBox @ OPRSDraggable new.
	announcedEvents := OrderedCollection new.
	canvas when: OPRSElementsDraggedEvent do: [ :each | announcedEvents add: each ] for: self.
	labelBox announce: (RSMouseDragStart new
			 shape: labelBox;
			 canvas: canvas;
			 position: labelBox position;
			 yourself).
	labelBox translateBy: 10 @ 5.
	labelBox announce: (RSMouseDragEnd new
			 shape: labelBox;
			 canvas: canvas;
			 position: labelBox position;
			 yourself).
	self assert: announcedEvents size equals: 1.
	event := announcedEvents first.
	self assert: (event hasInitialAnchorFor: labelBox) description: 'Dragged anchored shape should include initial anchor state'.
	self assert: (event initialAnchorFor: labelBox) equals: { 0.5. 12 }
]

{ #category : 'tests' }
OPRSDraggableTest >> testDragShapeAnnouncesElementsDraggedEvent [

	| canvas box announcedEvents event |
	canvas := RSCanvas new.
	box := RSBox new
		       extent: 40 @ 30;
		       translateTo: 50 @ 50;
		       yourself.
	canvas add: box.
	box @ OPRSDraggable new.
	announcedEvents := OrderedCollection new.
	canvas when: OPRSElementsDraggedEvent do: [ :each | announcedEvents add: each ] for: self.
	box announce: (RSMouseDragStart new
			 shape: box;
			 canvas: canvas;
			 position: 50 @ 50;
			 yourself).
	box announce: (RSMouseDragging new
			 shape: box;
			 canvas: canvas;
			 step: 20 @ 15;
			 yourself).
	box announce: (RSMouseDragEnd new
			 shape: box;
			 canvas: canvas;
			 position: 70 @ 65;
			 yourself).
	self assert: announcedEvents size equals: 1.
	event := announcedEvents first.
	self assertCollection: event shapes equals: { box }.
	self assert: (event initialPositions at: box) equals: 50 @ 50.
	self assertEmpty: event initialAnchors.
	self assertEmpty: event lines.
	self assertEmpty: event initialLineControlPoints
]

{ #category : 'tests' }
OPRSDraggableTest >> testDragWithoutMovementDoesNotAnnounceElementsDraggedEvent [

	| canvas box announcedEvents |
	canvas := RSCanvas new.
	box := RSBox new
		       size: 30;
		       translateTo: 40 @ 40;
		       yourself.
	canvas add: box.
	box @ OPRSDraggable new.
	announcedEvents := OrderedCollection new.
	canvas when: OPRSElementsDraggedEvent do: [ :each | announcedEvents add: each ] for: self.
	box announce: (RSMouseDragStart new
			 shape: box;
			 canvas: canvas;
			 position: 40 @ 40;
			 yourself).
	box announce: (RSMouseDragEnd new
			 shape: box;
			 canvas: canvas;
			 position: 40 @ 40;
			 yourself).
	self assertEmpty: announcedEvents
]

{ #category : 'tests' }
OPRSDraggableTest >> testElementsDraggedEventLazyDefaults [

	| event |
	event := OPRSElementsDraggedEvent new.
	self assertEmpty: event initialAnchors.
	self assertEmpty: event initialLineControlPoints.
	self assertEmpty: event lines
]
