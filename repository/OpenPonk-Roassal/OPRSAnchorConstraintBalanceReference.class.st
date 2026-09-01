"
Specific anchoring reference strategy that positions a shape at a proportional distance (a balance percentage from 0.0 to 1.0) along a path's total length.
"
Class {
	#name : 'OPRSAnchorConstraintBalanceReference',
	#superclass : 'OPRSAnchorConstraintReference',
	#instVars : [
		'balance'
	],
	#category : 'OpenPonk-Roassal-AnchorConstraint',
	#package : 'OpenPonk-Roassal',
	#tag : 'AnchorConstraint'
}

{ #category : 'instance creation' }
OPRSAnchorConstraintBalanceReference class >> balance: aNumber [

	^ self new
		  balance: aNumber;
		  yourself
]

{ #category : 'geometry' }
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

{ #category : 'accessing' }
OPRSAnchorConstraintBalanceReference >> balance: aNumber [

	balance := aNumber
]

{ #category : 'computing' }
OPRSAnchorConstraintBalanceReference >> computeAbsoluteBalanceForLength: aNumber [

	^ aNumber * ((balance min: 1) max: 0)
]

{ #category : 'actions' }
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
