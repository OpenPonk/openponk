Class {
	#name : 'OPRSAnchorConstraintReference',
	#superclass : 'RSObject',
	#category : 'OpenPonk-Roassal-AnchorConstraint',
	#package : 'OpenPonk-Roassal',
	#tag : 'AnchorConstraint'
}

{ #category : 'as yet unclassified' }
OPRSAnchorConstraintReference >> anchorSegmentFrom: segments andPointFrom: lenghtFromStart [

	^ self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
OPRSAnchorConstraintReference >> computeAbsoluteBalanceForLength: aNumber [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
OPRSAnchorConstraintReference >> guideLineTargetFor: anchorConstraint [

	^ anchorConstraint anchorShape
]

{ #category : 'as yet unclassified' }
OPRSAnchorConstraintReference >> saveShapePositionIn: aConstraint [

	self subclassResponsibility
]
