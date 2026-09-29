"
Specific anchoring strategy that positions a constrained shape at a fixed absolute pixel distance measured backward from the *end* point of a segmented line.
"
Class {
	#name : 'OPRSAnchorConstraintEndDistanceReference',
	#superclass : 'OPRSAnchorConstraintFixedDistanceReference',
	#category : 'OpenPonk-Roassal-AnchorConstraint',
	#package : 'OpenPonk-Roassal',
	#tag : 'AnchorConstraint'
}

{ #category : 'geometry' }
OPRSAnchorConstraintEndDistanceReference >> anchorSegmentFrom: segments andPointFrom: lenghtFromStart [

	^ segments last -> (segments last pointAtLength:
		   lenghtFromStart - (segments allButLast sum: #length))
]

{ #category : 'computing' }
OPRSAnchorConstraintEndDistanceReference >> computeAbsoluteBalanceForLength: aNumber [

	^ aNumber - distance
]

{ #category : 'geometry' }
OPRSAnchorConstraintEndDistanceReference >> farPointOfSegment: aSegment [

	^ aSegment from
]

{ #category : 'geometry' }
OPRSAnchorConstraintEndDistanceReference >> referencePointOfSegment: aSegment [

	^ aSegment to
]

{ #category : 'geometry' }
OPRSAnchorConstraintEndDistanceReference >> segmentIn: aConstraint [

	^ aConstraint createUpdater segments last
]
