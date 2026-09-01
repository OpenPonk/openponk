"
Specific anchoring reference strategy that positions a shape at a fixed absolute pixel distance from either the start or the end of a path.
"
Class {
	#name : 'OPRSAnchorConstraintFixedDistanceReference',
	#superclass : 'OPRSAnchorConstraintReference',
	#instVars : [
		'distance'
	],
	#category : 'OpenPonk-Roassal-AnchorConstraint',
	#package : 'OpenPonk-Roassal',
	#tag : 'AnchorConstraint'
}

{ #category : 'accessing' }
OPRSAnchorConstraintFixedDistanceReference class >> distance: anInteger [

	^ self new
		  distance: anInteger;
		  yourself
]

{ #category : 'accessing' }
OPRSAnchorConstraintFixedDistanceReference >> distance: anInteger [

	distance := anInteger
]

{ #category : 'geometry' }
OPRSAnchorConstraintFixedDistanceReference >> farPointOfSegment: aSegment [

	^ self subclassResponsibility
]

{ #category : 'geometry' }
OPRSAnchorConstraintFixedDistanceReference >> referencePointOfSegment: aSegment [

	^ self subclassResponsibility
]

{ #category : 'actions' }
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

{ #category : 'geometry' }
OPRSAnchorConstraintFixedDistanceReference >> segmentIn: aConstraint [

	^ self subclassResponsibility
]
