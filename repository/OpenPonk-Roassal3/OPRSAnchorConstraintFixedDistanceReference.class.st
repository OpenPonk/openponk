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
OPRSAnchorConstraintFixedDistanceReference >> referencePointOfSegment: aSegment [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintFixedDistanceReference >> saveShapePositionIn: aConstraint [

	| segment pointOnLine absoluteMinDistance |
	segment := self segmentIn: aConstraint.
	pointOnLine := segment nearestAlongPointTo: aConstraint shape position.
	distance := (self referencePointOfSegment: segment) distanceTo:
		            pointOnLine.
	absoluteMinDistance := pointOnLine distanceTo:
		                       aConstraint shape position.
	aConstraint minDistance: absoluteMinDistance
		* (segment sideOfPoint: aConstraint shape position)
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintFixedDistanceReference >> segmentIn: aConstraint [

	^ self subclassResponsibility
]
