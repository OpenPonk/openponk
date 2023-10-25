Class {
	#name : #OPRSAnchorConstraintEndDistanceReference,
	#superclass : #OPRSAnchorConstraintFixedDistanceReference,
	#category : #'OpenPonk-Roassal-AnchorConstraint'
}

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintEndDistanceReference >> anchorSegmentFrom: segments andPointFrom: lenghtFromStart [

	^ segments last -> (segments last pointAtLength:
		   lenghtFromStart - (segments allButLast sum: #length))
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintEndDistanceReference >> computeAbsoluteBalanceForLength: aNumber [

	^ aNumber - distance
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintEndDistanceReference >> farPointOfSegment: aSegment [

	^ aSegment from
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintEndDistanceReference >> referencePointOfSegment: aSegment [

	^ aSegment to
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintEndDistanceReference >> segmentIn: aConstraint [

	^ aConstraint createUpdater segments last
]
