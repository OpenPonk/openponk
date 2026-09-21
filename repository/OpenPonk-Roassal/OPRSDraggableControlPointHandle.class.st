"
Draggable handle bound to an edge control point. Tracks drag gestures to announce waypoints changes and supports undoable point removal.
"
Class {
	#name : 'OPRSDraggableControlPointHandle',
	#superclass : 'OPRSAbstractDraggableControlPointHandle',
	#instVars : [
		'indexOfControlPoint',
		'initialWaypoints'
	],
	#category : 'OpenPonk-Roassal-Polyline',
	#package : 'OpenPonk-Roassal',
	#tag : 'Polyline'
}

{ #category : 'actions' }
OPRSDraggableControlPointHandle >> basicRemovePoint [
	line controlPoints ifEmpty: [ ^ self ].
	(line from = line to and: [ line controlPoints size <= 4 ]) ifTrue: [ ^ self ].
	line controlPoints:
		(line controlPoints first: indexOfControlPoint - 1)
		, (line controlPoints allButFirst: indexOfControlPoint)
]

{ #category : 'actions' }
OPRSDraggableControlPointHandle >> changedPositionBy: anEvent [

	line
		controlPoints: (line controlPoints
				 copyReplaceFrom: indexOfControlPoint
				 to: indexOfControlPoint
				 with: { anEvent newPosition });
		update.

	line
		propertyAt: OPRSDraggableCPController
		put: line from encompassingRectangle copy.

	line announce: OPRSDraggedControlPointsEvent new
]

{ #category : 'rendering' }
OPRSDraggableControlPointHandle >> constraint [

	| moveBlock |
	moveBlock := [ self updatePosition ].
	moveBlock value.
	line from when: RSPositionChangedEvent do: moveBlock for: self.
	line to when: RSPositionChangedEvent do: moveBlock for: self.
	line from when: RSExtentChangedEvent do: moveBlock for: self.
	line to when: RSExtentChangedEvent do: moveBlock for: self
]

{ #category : 'accessing' }
OPRSDraggableControlPointHandle >> controlPoint [
	"Answer the control point at my index directly. Fails fast if index is invalid."
	^ line controlPoints at: indexOfControlPoint
]

{ #category : 'accessing' }
OPRSDraggableControlPointHandle >> indexOfControlPoint [
	"Answer my control point index within the polyline."
	^ indexOfControlPoint
]

{ #category : 'accessing' }
OPRSDraggableControlPointHandle >> initialWaypoints: aCollection [
	"Set the initial waypoints captured before control point promotion."
	initialWaypoints := aCollection copy
]

{ #category : 'accessing' }
OPRSDraggableControlPointHandle >> on: aLine atControlPoint: anIndex [

	line := aLine.
	indexOfControlPoint := anIndex
]

{ #category : 'events' }
OPRSDraggableControlPointHandle >> onDragEnd [
	self onDragEnd: nil
]

{ #category : 'events' }
OPRSDraggableControlPointHandle >> onDragEnd: anEvent [
	| targetLine previousControlPoint nextControlPoint oldWaypoints newWaypoints isRemoved |
	line ifNil: [ ^ self ].
	targetLine := line.
	oldWaypoints := initialWaypoints ifNil: [ targetLine controlPoints copy ].
	initialWaypoints := nil.

	"Guard against zero-delta drag: if waypoints did not change, abort immediately without removing collinear points"
	oldWaypoints = targetLine controlPoints ifTrue: [ ^ self ].

	isRemoved := false.
	previousControlPoint := targetLine controlPoints at: indexOfControlPoint - 1.
	nextControlPoint := targetLine controlPoints at: indexOfControlPoint + 1.
	(self controlPoint
		onLineFrom: previousControlPoint
		to: nextControlPoint
		within: (nextControlPoint distanceTo: previousControlPoint) * 0.03 + 4) ifTrue: [
			self basicRemovePoint.
			isRemoved := true ].
	newWaypoints := targetLine controlPoints copy.
	oldWaypoints ~= newWaypoints ifTrue: [
		targetLine propertyAt: OPRSDraggableControlPoints ifPresent: [ :controlPointsInteraction |
			controlPointsInteraction
				announceWaypointsChangedFor: targetLine
				old: oldWaypoints
				new: newWaypoints ] ].
	(isRemoved and: [ line isNotNil ]) ifTrue: [
		targetLine propertyAt: OPRSDraggableControlPoints ifPresent: [ :controlPointsInteraction |
			controlPointsInteraction rebuild ] ]
]

{ #category : 'event handling' }
OPRSDraggableControlPointHandle >> onDragStart: anEvent [
	"Capture initial waypoints only if they were not already supplied during midpoint promotion."
	initialWaypoints ifNil: [ initialWaypoints := line controlPoints copy ]
]

{ #category : 'actions' }
OPRSDraggableControlPointHandle >> remove [

	self removeConnectedEdges.
	super remove
]

{ #category : 'actions' }
OPRSDraggableControlPointHandle >> removeConnectedEdges [
	"remove connected edges without triggering removal cascade"
	shape connectedLines removeAll
]

{ #category : 'removing' }
OPRSDraggableControlPointHandle >> removePoint [
	"Remove this control point and announce waypoints changed event to record an undoable command."
	| oldWaypoints targetLine controlPointsInteraction |
	targetLine := line.
	oldWaypoints := targetLine controlPoints copy.
	self basicRemovePoint.
	controlPointsInteraction := targetLine propertyAt: OPRSDraggableControlPoints ifAbsent: [ nil ].
	controlPointsInteraction ifNotNil: [
		controlPointsInteraction
			announceWaypointsChangedFor: targetLine
			old: oldWaypoints
			new: targetLine controlPoints copy ]
]

{ #category : 'rendering' }
OPRSDraggableControlPointHandle >> render [
	shape := self createShape.
	shape model: line.
	clickBox := self createClickBoxShape.
	clickBox model: line.
	line canvas
		add: shape;
		add: clickBox.
	self constraint.
	RSLocation new stick: shape on: clickBox.
	clickBox @ RSDraggable.

	clickBox
		when: RSMouseDragStart send: #onDragStart: to: self;
		when: RSMouseDragEnd send: #onDragEnd: to: self.

	shape
		when: RSPositionChangedEvent
		do: [ :event | self changedPositionBy: event ]
		for: self.

	(line from ~= line to or: [ line controlPoints size > 4 ]) ifTrue: [
		shape @ (RSMenuActivable new menuDo: [ :menu :box |
			 menu
				 add: 'Remove point'
				 target: self
				 selector: #removePoint
				 argument: #(  );
				 add: 'Straighten line'
				 target: self
				 selector: #straightenConnection
				 argument: #(  ) ]) ]
]

{ #category : 'accessing' }
OPRSDraggableControlPointHandle >> size [

	^ 9
]

{ #category : 'removing' }
OPRSDraggableControlPointHandle >> straightenConnection [
	"Remove all inner control points and announce waypoints changed event to record an undoable command."
	| oldWaypoints targetLine controlPointsInteraction |
	line controlPoints ifEmpty: [ ^ self ].
	targetLine := line.
	oldWaypoints := targetLine controlPoints copy.
	targetLine innerControlPoints: #( ).
	controlPointsInteraction := targetLine propertyAt: OPRSDraggableControlPoints ifAbsent: [ nil ].
	controlPointsInteraction ifNotNil: [
		controlPointsInteraction
			announceWaypointsChangedFor: targetLine
			old: oldWaypoints
			new: targetLine controlPoints copy ]
]

{ #category : 'updating' }
OPRSDraggableControlPointHandle >> updatePosition [
	"Translate clickBox to the current control point position."
	clickBox translateTo: self controlPoint
]
