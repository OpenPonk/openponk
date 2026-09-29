"
Specific anchoring strategy that positions a constrained shape at a fixed absolute pixel distance measured forward from the *start* point of a segmented line.
"
Class {
	#name : 'OPRSAnchorConstraintStartDistanceReference',
	#superclass : 'OPRSAnchorConstraintFixedDistanceReference',
	#category : 'OpenPonk-Roassal-AnchorConstraint',
	#package : 'OpenPonk-Roassal',
	#tag : 'AnchorConstraint'
}

{ #category : 'geometry' }
OPRSAnchorConstraintStartDistanceReference >> anchorSegmentFrom: segments andPointFrom: lenghtFromStart [

	^ segments first -> (segments first pointAtLength: lenghtFromStart)
]

{ #category : 'computing' }
OPRSAnchorConstraintStartDistanceReference >> computeAbsoluteBalanceForLength: aNumber [

	^ distance
]

{ #category : 'geometry' }
OPRSAnchorConstraintStartDistanceReference >> farPointOfSegment: aSegment [

	^ aSegment to
]

{ #category : 'geometry' }
OPRSAnchorConstraintStartDistanceReference >> referencePointOfSegment: aSegment [

	^ aSegment from
]

{ #category : 'geometry' }
OPRSAnchorConstraintStartDistanceReference >> segmentIn: aConstraint [

	^ aConstraint createUpdater segments first
]
