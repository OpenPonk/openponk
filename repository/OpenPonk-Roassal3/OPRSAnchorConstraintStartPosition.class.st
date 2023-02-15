Class {
	#name : #OPRSAnchorConstraintStartPosition,
	#superclass : #OPRSAnchorConstraintFixedPosition,
	#category : #'OpenPonk-Roassal3-AnchorConstraint'
}

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintStartPosition >> anchorSegmentFrom: segments andPointFrom: lenghtFromStart [

	^ segments first -> (segments first pointAtLength: lenghtFromStart)
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintStartPosition >> computeAbsoluteBalanceForLength: aNumber [

	^ distance
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintStartPosition >> referencePointOfSegment: aSegment [

	^ aSegment from
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintStartPosition >> segmentIn: aConstraint [

	^ aConstraint createUpdater segments first
]
