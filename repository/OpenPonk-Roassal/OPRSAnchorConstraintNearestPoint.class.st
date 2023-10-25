Class {
	#name : #OPRSAnchorConstraintNearestPoint,
	#superclass : #RSObject,
	#instVars : [
		'segment',
		'point',
		'previousSegmentsLength',
		'lineLength'
	],
	#category : #'OpenPonk-Roassal-AnchorConstraint'
}

{ #category : #calculated }
OPRSAnchorConstraintNearestPoint >> balance [

	lineLength isZero ifTrue: [ ^ 0.5 ].
	^ self lengthFromLineStart / lineLength
]

{ #category : #calculated }
OPRSAnchorConstraintNearestPoint >> distanceAlongLineToRectangle: aRectangle [

	| pointAlongLine |
	pointAlongLine := aRectangle center
		                  nearestPointAlongLineFrom: segment from
		                  to: segment to.
	^ (aRectangle pointNearestTo: pointAlongLine) distanceTo:
		  pointAlongLine
]

{ #category : #calculated }
OPRSAnchorConstraintNearestPoint >> distanceTo: aPoint [

	^ point distanceTo: aPoint
]

{ #category : #calculated }
OPRSAnchorConstraintNearestPoint >> distanceToRectangle: aRectangle [

	^ (aRectangle pointNearestTo: point) distanceTo: point
]

{ #category : #calculated }
OPRSAnchorConstraintNearestPoint >> lengthFromLineStart [

	^ previousSegmentsLength + self lengthFromSegmentStart
]

{ #category : #calculated }
OPRSAnchorConstraintNearestPoint >> lengthFromSegmentStart [

	^ segment from distanceTo: point
]

{ #category : #accessing }
OPRSAnchorConstraintNearestPoint >> lineLength: anObject [

	lineLength := anObject
]

{ #category : #accessing }
OPRSAnchorConstraintNearestPoint >> point: anObject [

	point := anObject
]

{ #category : #accessing }
OPRSAnchorConstraintNearestPoint >> previousSegmentsLength: anObject [

	previousSegmentsLength := anObject
]

{ #category : #accessing }
OPRSAnchorConstraintNearestPoint >> segment: anObject [

	segment := anObject
]

{ #category : #geometry }
OPRSAnchorConstraintNearestPoint >> sideOfPoint: aPoint [

	^ segment sideOfPoint: aPoint
]
