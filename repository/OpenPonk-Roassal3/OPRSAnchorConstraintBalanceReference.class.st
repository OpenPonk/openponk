Class {
	#name : #OPRSAnchorConstraintBalanceReference,
	#superclass : #OPRSAnchorConstraintReference,
	#instVars : [
		'balance'
	],
	#category : #'OpenPonk-Roassal3-AnchorConstraint'
}

{ #category : #'instance creation' }
OPRSAnchorConstraintBalanceReference class >> balance: aNumber [

	^ self new
		  balance: aNumber;
		  yourself
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintBalanceReference >> anchorSegmentFrom: segments andPointFrom: lenghtFromStart [

	| sum newSum |
	sum := 0.
	segments do: [ :each | 
		newSum := sum + each length.
		(lenghtFromStart between: sum and: newSum) ifTrue: [ 
			^ each -> (each pointAtLength: lenghtFromStart - sum) ].
		sum := newSum ].
	self error: 'failed to find a segment'
]

{ #category : #accessing }
OPRSAnchorConstraintBalanceReference >> balance: aNumber [

	balance := aNumber
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintBalanceReference >> computeAbsoluteBalanceForLength: aNumber [

	^ aNumber * ((balance min: 1) max: 0)
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintBalanceReference >> guideLineTargetFor: anchorConstraint [

	^ anchorConstraint anchorShape
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintBalanceReference >> saveShapePositionIn: aConstraint [

	| nearestPointInfo absoluteMinDistance |
	nearestPointInfo := aConstraint createUpdater nearestPointInfo.
	balance := nearestPointInfo balance.
	absoluteMinDistance := nearestPointInfo distanceTo:
		                       aConstraint shape position.
	aConstraint minDistance: absoluteMinDistance
		* (nearestPointInfo sideOfPoint: aConstraint shape position)
]
