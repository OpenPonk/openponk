Class {
	#name : #OPRSMidpointHandle,
	#superclass : #OPRSHandle,
	#instVars : [
		'from',
		'to',
		'nearStart',
		'nearEnd'
	],
	#category : #'OpenPonk-Roassal3-Polyline'
}

{ #category : #'as yet unclassified' }
OPRSMidpointHandle >> beNearEnd [
	nearEnd := true
]

{ #category : #'as yet unclassified' }
OPRSMidpointHandle >> beNearStart [
	nearStart := true
]

{ #category : #'as yet unclassified' }
OPRSMidpointHandle >> constraintFor: aShape [

	| moveBlock |
	moveBlock := [ aShape translateTo: self fromPoint + self toPoint / 2 ].
	moveBlock value.
	from when: RSPositionChangedEvent do: moveBlock.
	to when: RSPositionChangedEvent do: moveBlock.
	from when: RSExtentChangedEvent do: moveBlock.
	to when: RSExtentChangedEvent do: moveBlock.
	from when: RSShapeRemovedEvent do: [ 
		to announcer unsubscribe: self.
		from announcer unsubscribe: self ].
	to when: RSShapeRemovedEvent do: [ 
		from announcer unsubscribe: self.
		to announcer unsubscribe: self ]
]

{ #category : #'as yet unclassified' }
OPRSMidpointHandle >> from [
	^ from
]

{ #category : #'as yet unclassified' }
OPRSMidpointHandle >> fromPoint [

	^ nearStart
		  ifTrue: [ line controlPoints first ]
		  ifFalse: [ from position ]
]

{ #category : #'as yet unclassified' }
OPRSMidpointHandle >> initialize [
	super initialize.
	nearStart := nearEnd := false
]

{ #category : #'as yet unclassified' }
OPRSMidpointHandle >> on: aLine between: fromShape and: toShape [

	line := aLine.
	from := fromShape.
	to := toShape
]

{ #category : #'as yet unclassified' }
OPRSMidpointHandle >> promote [

	(self fromPoint distanceTo: self toPoint) > 10 ifFalse: [ ^ self ].
	(line propertyAt: OPRSPolylineHandles) promoteFor: line handle: self
]

{ #category : #removing }
OPRSMidpointHandle >> remove [

	super remove.
	from announcer unsubscribe: self.
	to announcer unsubscribe: self.
	from := nil.
	to := nil
]

{ #category : #'as yet unclassified' }
OPRSMidpointHandle >> render [

	shape := self createShape.
	shape model: line.
	clickBox := self createClickBoxShape.
	clickBox model: line.
	clickBox @ (OPRSConditionallyDraggable onCondition: [ 
		 (self fromPoint distanceTo: self toPoint) > 10 ]).
	self constraintFor: clickBox.
	RSLocation new stick: shape on: clickBox.
	clickBox when: RSMouseDragStart do: [ :event | self promote ].
	clickBox when: RSMouseLeftClick do: [ :event | self promote ].
	line canvas
		add: shape;
		add: clickBox
]

{ #category : #accessing }
OPRSMidpointHandle >> size [

	^ 5
]

{ #category : #'as yet unclassified' }
OPRSMidpointHandle >> to [
	^ to
]

{ #category : #'as yet unclassified' }
OPRSMidpointHandle >> toPoint [

	^ nearEnd
		  ifTrue: [ line controlPoints last ]
		  ifFalse: [ to position ]
]
