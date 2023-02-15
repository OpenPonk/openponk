Class {
	#name : #OPRSAnchorConstraintFixedPosition,
	#superclass : #OPRSAnchorConstraintPosition,
	#instVars : [
		'distance'
	],
	#category : #'OpenPonk-Roassal3-AnchorConstraint'
}

{ #category : #accessing }
OPRSAnchorConstraintFixedPosition class >> distance: anInteger [

	^ self new
		  distance: anInteger;
		  yourself
]

{ #category : #accessing }
OPRSAnchorConstraintFixedPosition >> distance: anInteger [

	distance := anInteger
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintFixedPosition >> referencePointOfSegment: aSegment [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintFixedPosition >> saveShapePositionIn: aConstraint [

	| segment pointOnLine absoluteMinDistance |
	segment := self segmentIn: aConstraint.
	pointOnLine := segment nearestAlongPointTo: aConstraint shape.
	distance := (self referencePointOfSegment: segment) distanceTo:
		            pointOnLine.
	absoluteMinDistance := pointOnLine distanceTo:
		                       aConstraint shape position.
	aConstraint minDistance: absoluteMinDistance
		* (segment sideOfPoint: aConstraint shape position)
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintFixedPosition >> segmentIn: aConstraint [

	^ self subclassResponsibility
]
