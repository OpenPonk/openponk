Class {
	#name : #OPRSAnchorConstraintEndPosition,
	#superclass : #OPRSAnchorConstraintFixedPosition,
	#category : #'OpenPonk-Roassal3-AnchorConstraint'
}

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintEndPosition >> anchorSegmentFrom: segments andPointFrom: lenghtFromStart [

	^ segments last -> (segments last pointAtLength:
		   lenghtFromStart - (segments allButLast sum: #length))
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintEndPosition >> computeAbsoluteBalanceForLength: aNumber [

	^ aNumber - distance
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintEndPosition >> referencePointOfSegment: aSegment [

	^ aSegment to
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintEndPosition >> segmentIn: aConstraint [

	^ aConstraint createUpdater segments last
]
