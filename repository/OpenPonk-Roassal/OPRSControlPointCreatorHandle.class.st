"
Specialized transient handle that appears on a selected edge to allow the user to click and drag to create a brand new routing control point mid-segment.
"
Class {
	#name : 'OPRSControlPointCreatorHandle',
	#superclass : 'OPRSAbstractDraggableControlPointHandle',
	#instVars : [
		'from',
		'to',
		'nearStart',
		'nearEnd'
	],
	#category : 'OpenPonk-Roassal-Polyline',
	#package : 'OpenPonk-Roassal',
	#tag : 'Polyline'
}

{ #category : 'action' }
OPRSControlPointCreatorHandle >> basicPromote [
	"Perform silent control point promotion without announcing waypoints changed event to prevent premature rebuild during drag gesture."
	(self fromPoint distanceTo: self toPoint) > 10 ifFalse: [ ^ self ].
	(line propertyAt: OPRSDraggableControlPoints) promoteFor: line handle: self
]

{ #category : 'actions' }
OPRSControlPointCreatorHandle >> beNearEnd [
	nearEnd := true
]

{ #category : 'actions' }
OPRSControlPointCreatorHandle >> beNearStart [
	nearStart := true
]

{ #category : 'rendering' }
OPRSControlPointCreatorHandle >> constraintFor: aShape [

	| moveBlock |
	moveBlock := [ aShape translateTo: self fromPoint + self toPoint / 2 ].
	moveBlock value.
	from when: RSPositionChangedEvent do: moveBlock for: self.
	to when: RSPositionChangedEvent do: moveBlock for: self.
	from when: RSExtentChangedEvent do: moveBlock for: self.
	to when: RSExtentChangedEvent do: moveBlock for: self
]

{ #category : 'accessing' }
OPRSControlPointCreatorHandle >> from [
	^ from
]

{ #category : 'accessing' }
OPRSControlPointCreatorHandle >> fromPoint [

	^ nearStart
		  ifTrue: [ line controlPoints first ]
		  ifFalse: [ from position ]
]

{ #category : 'initialization' }
OPRSControlPointCreatorHandle >> initialize [
	super initialize.
	nearStart := nearEnd := false
]

{ #category : 'accessing' }
OPRSControlPointCreatorHandle >> on: aLine between: fromShape and: toShape [

	line := aLine.
	from := fromShape.
	to := toShape
]

{ #category : 'action' }
OPRSControlPointCreatorHandle >> promote [
	"Promote control point and announce waypoints changed event to record an undoable command for discrete user clicks."
	| targetLine oldWaypoints interaction |
	(self fromPoint distanceTo: self toPoint) > 10 ifFalse: [ ^ self ].
	targetLine := line.
	oldWaypoints := targetLine controlPoints copy.
	interaction := targetLine propertyAt: OPRSDraggableControlPoints.
	interaction promoteFor: targetLine handle: self.
	interaction
		announceWaypointsChangedFor: targetLine
		old: oldWaypoints
		new: targetLine controlPoints copy
]

{ #category : 'actions' }
OPRSControlPointCreatorHandle >> remove [

	super remove.
	from announcer unsubscribe: self.
	to announcer unsubscribe: self.
	from := nil.
	to := nil
]

{ #category : 'rendering' }
OPRSControlPointCreatorHandle >> render [
	shape := self createShape.
	shape model: line.
	clickBox := self createClickBoxShape.
	clickBox model: line.
	clickBox @ (OPRSConditionallyDraggable onCondition: [
		 (self fromPoint distanceTo: self toPoint) > 10 ]).
	self constraintFor: clickBox.
	RSLocation new stick: shape on: clickBox.
	clickBox
		when: RSMouseDragStart
		do: [ :event | self basicPromote ]
		for: self.
	clickBox
		when: RSMouseLeftClick
		do: [ :event | self promote ]
		for: self.
	line canvas
		add: shape;
		add: clickBox
]

{ #category : 'accessing' }
OPRSControlPointCreatorHandle >> size [

	^ 5
]

{ #category : 'accessing' }
OPRSControlPointCreatorHandle >> to [
	^ to
]

{ #category : 'accessing' }
OPRSControlPointCreatorHandle >> toPoint [

	^ nearEnd
		  ifTrue: [ line controlPoints last ]
		  ifFalse: [ to position ]
]
