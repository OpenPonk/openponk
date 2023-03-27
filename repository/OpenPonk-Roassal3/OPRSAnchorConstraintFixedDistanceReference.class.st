Class {
	#name : #OPRSAnchorConstraintFixedDistanceReference,
	#superclass : #OPRSAnchorConstraintReference,
	#instVars : [
		'distance'
	],
	#category : #'OpenPonk-Roassal3-AnchorConstraint'
}

{ #category : #accessing }
OPRSAnchorConstraintFixedDistanceReference class >> distance: anInteger [

	^ self new
		  distance: anInteger;
		  yourself
]

{ #category : #accessing }
OPRSAnchorConstraintFixedDistanceReference >> distance: anInteger [

	distance := anInteger
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintFixedDistanceReference >> farPointOfSegment: aSegment [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintFixedDistanceReference >> referencePointOfSegment: aSegment [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintFixedDistanceReference >> saveShapePositionIn: aConstraint [

	| segment pointAlongLine pointOnLine absoluteDistanceToLine distanceToLine referencePoint |
	segment := self segmentIn: aConstraint.

	pointAlongLine := aConstraint shape position
		                  nearestPointAlongLineFrom: segment from
		                  to: segment to.

	absoluteDistanceToLine := (aConstraint shape encompassingRectangle
		                           pointNearestTo: pointAlongLine)
		                          distanceTo: pointAlongLine.

	distanceToLine := absoluteDistanceToLine
	                  * (segment sideOfPoint: aConstraint shape position).

	aConstraint distanceToLine: distanceToLine.

	pointOnLine := pointAlongLine adhereTo:
		               (segment from rectangle: segment to).

	referencePoint := self referencePointOfSegment: segment.

	distance := pointOnLine distanceTo: referencePoint
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintFixedDistanceReference >> segmentIn: aConstraint [

	^ self subclassResponsibility
]
