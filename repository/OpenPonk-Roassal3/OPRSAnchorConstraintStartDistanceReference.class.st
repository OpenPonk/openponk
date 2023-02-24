Class {
	#name : #OPRSAnchorConstraintStartDistanceReference,
	#superclass : #OPRSAnchorConstraintFixedDistanceReference,
	#category : #'OpenPonk-Roassal3-AnchorConstraint'
}

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintStartDistanceReference >> anchorSegmentFrom: segments andPointFrom: lenghtFromStart [

	^ segments first -> (segments first pointAtLength: lenghtFromStart)
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintStartDistanceReference >> computeAbsoluteBalanceForLength: aNumber [

	^ distance
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintStartDistanceReference >> guideLineTargetFor: anchorConstraint [

	^ anchorConstraint line startPoint 
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintStartDistanceReference >> referencePointOfSegment: aSegment [

	^ aSegment from
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintStartDistanceReference >> segmentIn: aConstraint [

	^ aConstraint createUpdater segments first
]
