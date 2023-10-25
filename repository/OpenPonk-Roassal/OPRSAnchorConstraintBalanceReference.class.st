Class {
	#name : #OPRSAnchorConstraintBalanceReference,
	#superclass : #OPRSAnchorConstraintReference,
	#instVars : [
		'balance'
	],
	#category : #'OpenPonk-Roassal-AnchorConstraint'
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
OPRSAnchorConstraintBalanceReference >> saveShapePositionIn: aConstraint [

	| nearestPointInfo absoluteDistanceToLine distanceToLine |
	nearestPointInfo := aConstraint createUpdater nearestPointInfo.

	absoluteDistanceToLine := nearestPointInfo
		                          distanceAlongLineToRectangle:
		                          aConstraint shape encompassingRectangle.

	distanceToLine := absoluteDistanceToLine
	                  *
	                  (nearestPointInfo sideOfPoint:
		                   aConstraint shape position).

	aConstraint distanceToLine: distanceToLine.

	balance := nearestPointInfo balance
]
