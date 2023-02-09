Class {
	#name : #OPRSAnchorConstraintPosition,
	#superclass : #RSObject,
	#category : #'OpenPonk-Roassal3-AnchorConstraint'
}

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintPosition >> anchorSegmentFrom: segments andPointFrom: lenghtFromStart [

	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintPosition >> computeAbsoluteBalanceForLength: aNumber [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintPosition >> saveShapePositionIn: aConstraint [

	self subclassResponsibility
]
