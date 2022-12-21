Class {
	#name : #OPRSAnchorConstraint,
	#superclass : #RSObject,
	#instVars : [
		'minDistance',
		'balance',
		'anchorShape',
		'guideLine',
		'shape',
		'line'
	],
	#category : #'OpenPonk-Roassal3'
}

{ #category : #building }
OPRSAnchorConstraint >> addAnchorAndGuideLine [

	self anchorShape isInACanvas ifTrue: [ ^ self ].
	shape canvas add: self anchorShape.
	self guideLine
		from: shape;
		to: self anchorShape.
	shape canvas add: self guideLine.
	self moveShape.
	shape signalUpdate
]

{ #category : #building }
OPRSAnchorConstraint >> anchorShape [

	anchorShape ifNotNil: [ ^ anchorShape ].
	anchorShape := RSBox new.
	anchorShape
		size: 1;
		color: Color transparent.
	^ anchorShape
]

{ #category : #accessing }
OPRSAnchorConstraint >> balance [
	^ balance
]

{ #category : #accessing }
OPRSAnchorConstraint >> balance: aNumber [
	balance := aNumber
]

{ #category : #building }
OPRSAnchorConstraint >> build [

	shape propertyAt: self class put: self.
	shape when: RSShapeRemovedEvent do: [ self remove ].
	line when: RSShapeRemovedEvent do: [ self remove ].
	line from when: RSPositionChangedEvent do: [ self moveShape ].
	line to when: RSPositionChangedEvent do: [ self moveShape ].
	shape when: RSMouseLeftDragStart do: [ self addAnchorAndGuideLine ].
	shape when: RSMouseDragging do: [ self saveShapePosition ].
	shape when: RSMouseDragEnd do: [ self removeAnchorAndGuideLine ]
]

{ #category : #accessing }
OPRSAnchorConstraint >> createUpdater [

	^ OPRSAnchorConstraintUpdater new
		  line: line;
		  shape: shape;
		  anchorShape: anchorShape;
		  balance: balance;
		  minDistance: minDistance;
		  yourself
]

{ #category : #building }
OPRSAnchorConstraint >> guideLine [

	guideLine ifNotNil: [ ^ guideLine ].
	guideLine := RSLine new.
	^ guideLine
]

{ #category : #building }
OPRSAnchorConstraint >> initialize [

	super initialize.
	self useGuideLine
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

	| nearestPointInfo absoluteMinDistance |
	nearestPointInfo := self createUpdater nearestPointInfo.
	balance := nearestPointInfo balance.
	absoluteMinDistance := nearestPointInfo distanceTo: shape position.
	minDistance := absoluteMinDistance
	               * (nearestPointInfo sideOfPoint: shape position).
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
