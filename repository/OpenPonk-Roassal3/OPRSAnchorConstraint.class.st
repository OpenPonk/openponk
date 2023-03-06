Class {
	#name : #OPRSAnchorConstraint,
	#superclass : #RSObject,
	#instVars : [
		'minDistance',
		'anchorShape',
		'guideLine',
		'shape',
		'line',
		'positionReference',
		'alwaysShowGuideLine'
	],
	#category : #'OpenPonk-Roassal3-AnchorConstraint'
}

{ #category : #building }
OPRSAnchorConstraint >> addAnchorAndGuideLine [

	self anchorShape isInACanvas ifTrue: [ ^ self ].
	shape canvas add: self anchorShape.
	self guideLine
		from: shape;
		to: (positionReference guideLineTargetFor: self).
	shape canvas add: self guideLine.
	self moveShape.
	shape signalUpdate
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraint >> alwaysShowGuideLine [

	alwaysShowGuideLine := true.
	self guideLine color = (Color gray: 0.9) ifTrue: [ 
		self guideLine color: Color black ]
]

{ #category : #building }
OPRSAnchorConstraint >> anchorShape [

	anchorShape ifNotNil: [ ^ anchorShape ].
	anchorShape := RSBox new.
	anchorShape
		size: 0;
		color: Color transparent.
	^ anchorShape
]

{ #category : #accessing }
OPRSAnchorConstraint >> balance: aNumber [

	positionReference := OPRSAnchorConstraintBalanceReference new
		            balance: aNumber;
		            yourself
]

{ #category : #building }
OPRSAnchorConstraint >> build [

	shape propertyAt: self class put: self.
	shape when: RSShapeRemovedEvent do: [ self remove ].
	line when: RSShapeRemovedEvent do: [ self remove ].
	line from when: RSPositionChangedEvent do: [ self moveShape ].
	line to when: RSPositionChangedEvent do: [ self moveShape ].
	line when: OPRSDraggedControlPointsEvent do: [ self moveShape ].
	line when: RSPositionChangedEvent do: [ self moveShape ].
	shape when: RSMouseDragging do: [ self saveShapePosition ].
	alwaysShowGuideLine ifTrue: [ 
		^ shape isInACanvas
			  ifTrue: [ self addAnchorAndGuideLine ]
			  ifFalse: [ 
			  shape when: RSShapeAddedEvent do: [ self addAnchorAndGuideLine ] ] ].
	shape when: RSMouseLeftDragStart do: [ self addAnchorAndGuideLine ].
	shape when: RSMouseDragEnd do: [ self removeAnchorAndGuideLine ]
]

{ #category : #accessing }
OPRSAnchorConstraint >> createUpdater [

	^ OPRSAnchorConstraintUpdater new
		  line: line;
		  shape: shape;
		  anchorShape: anchorShape;
		  positionReference: positionReference;
		  minDistance: minDistance;
		  yourself
]

{ #category : #building }
OPRSAnchorConstraint >> guideLine [

	guideLine ifNotNil: [ ^ guideLine ].
	guideLine := RSLine new.
	guideLine withBorderAttachPoint.
	^ guideLine
]

{ #category : #building }
OPRSAnchorConstraint >> initialize [

	super initialize.
	self useGuideLine.
	alwaysShowGuideLine := false
]

{ #category : #accessing }
OPRSAnchorConstraint >> line [
	^ line
]

{ #category : #accessing }
OPRSAnchorConstraint >> minDistance [
	^ minDistance
]

{ #category : #accessing }
OPRSAnchorConstraint >> minDistance: anInteger [

	"Attempted distance from line to the right from the line looking from start to end. Negative number means to the right"

	minDistance := anInteger
]

{ #category : #updating }
OPRSAnchorConstraint >> moveShape [

	self createUpdater update
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraint >> noGuideLine [

	self guideLine color: Color transparent
]

{ #category : #accessing }
OPRSAnchorConstraint >> positionFromEnd: aNumber [

	positionReference := OPRSAnchorConstraintEndDistanceReference new
		           distance: aNumber;
		           yourself
]

{ #category : #accessing }
OPRSAnchorConstraint >> positionFromStart: aNumber [

	positionReference := OPRSAnchorConstraintStartDistanceReference new
		           distance: aNumber;
		           yourself
]

{ #category : #accessing }
OPRSAnchorConstraint >> positionReference: anAnchorConstraintReference [

	positionReference := anAnchorConstraintReference
]

{ #category : #building }
OPRSAnchorConstraint >> remove [

	shape announcer unsubscribe: self.
	line from announcer unsubscribe: self.
	line to announcer unsubscribe: self.
	self removeAnchorAndGuideLine
]

{ #category : #building }
OPRSAnchorConstraint >> removeAnchorAndGuideLine [

	anchorShape ifNotNil: [ anchorShape remove ].
	guideLine ifNotNil: [ guideLine remove ].
	shape signalUpdate
]

{ #category : #updating }
OPRSAnchorConstraint >> saveShapePosition [

	positionReference saveShapePositionIn: self.
	self createUpdater moveAnchor
]

{ #category : #accessing }
OPRSAnchorConstraint >> shape [
	^ shape
]

{ #category : #building }
OPRSAnchorConstraint >> stick: aShape on: aLine [

	shape := aShape.
	line := aLine.
	self build
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraint >> useGuideLine [

	self guideLine color: (Color gray: 0.9)
]
