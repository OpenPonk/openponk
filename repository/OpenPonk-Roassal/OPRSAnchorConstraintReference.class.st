"
Abstract base class defining reference strategies for how an anchor point is calculated along a path (e.g., by balance percentage or fixed distance).
"
Class {
	#name : 'OPRSAnchorConstraintReference',
	#superclass : 'RSObject',
	#category : 'OpenPonk-Roassal-AnchorConstraint',
	#package : 'OpenPonk-Roassal',
	#tag : 'AnchorConstraint'
}

{ #category : 'geometry' }
OPRSAnchorConstraintReference >> anchorSegmentFrom: segments andPointFrom: lenghtFromStart [

	^ self subclassResponsibility 
]

{ #category : 'computing' }
OPRSAnchorConstraintReference >> computeAbsoluteBalanceForLength: aNumber [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
OPRSAnchorConstraintReference >> guideLineTargetFor: anchorConstraint [

	^ anchorConstraint anchorShape
]

{ #category : 'actions' }
OPRSAnchorConstraintReference >> saveShapePositionIn: aConstraint [

	self subclassResponsibility
]
