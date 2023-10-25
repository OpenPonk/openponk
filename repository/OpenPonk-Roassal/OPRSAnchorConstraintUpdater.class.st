Class {
	#name : #OPRSAnchorConstraintUpdater,
	#superclass : #RSObject,
	#instVars : [
		'line',
		'minDistanceToLine',
		'distanceToLine',
		'anchorShape',
		'shape',
		'absoluteBalance',
		'segments',
		'anchorSegment',
		'anchorPoint',
		'extraDistance',
		'positionReference'
	],
	#category : #'OpenPonk-Roassal-AnchorConstraint'
}

{ #category : #building }
OPRSAnchorConstraintUpdater >> anchorPoint [

	anchorPoint ifNil: [ self computeAnchorSegmentAndPoint ].
	^ anchorPoint
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> anchorSegment [

	anchorSegment ifNil: [ self computeAnchorSegmentAndPoint ].
	^ anchorSegment
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> anchorShape: aShape [

	anchorShape := aShape
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> computeAnchorSegmentAndPoint [

	| pair |
	pair := positionReference
		        anchorSegmentFrom: self segments
		        andPointFrom: self lengthFromStartOfBalance.
	anchorSegment := pair key.
	anchorPoint := pair value
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintUpdater >> computeExtraDistance [

	"Compute the extra distance required to move the element to not overlap the segment."

	| sideOfElement normals |
	sideOfElement := self anchorSegment sideOfPoint: shape position.
	normals := shape encompassingRectangle corners
		           select: [ :each | 
		           (self anchorSegment sideOfPoint: each) ~= sideOfElement ]
		           thenCollect: [ :each | 
			           each distanceTo: (each
					            nearestPointAlongLineFrom: self anchorSegment from
					            to: self anchorSegment to) ].
	normals ifEmpty: [ ^ 0 ].
	^ distanceToLine sign > 0
		  ifTrue: [ normals max ]
		  ifFalse: [ normals max negated ]
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> distanceToLine: aNumber [

	distanceToLine := aNumber
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> extraDistance [

	^ extraDistance ifNil: [ extraDistance := self computeExtraDistance ]
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> lengthFromStartOfBalance [

	^ absoluteBalance ifNil: [ 
		  absoluteBalance := positionReference computeAbsoluteBalanceForLength:
			                     self lineLength ]
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> line: aLine [

	line := aLine
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> lineLength [

	^ self segments sumNumbers: [ :segment | segment length ]
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> minDistanceToLine [
	^ minDistanceToLine
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> minDistanceToLine: aNumber [
	minDistanceToLine := aNumber
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> moveAnchor [

	anchorShape ifNil: [ ^ self ].
	anchorShape translateTo: self anchorPoint
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> moveAwayFrom: aRectangle via: aVector [

	"There should be minDistance between the start and the element. Move it in the direction fo the current segment"

	| vector corners segment |
	"source and target of the edge on top of each other... ignore"
	aVector r isZero ifTrue: [ ^ self ].
	vector := aVector normalized
	          * (aRectangle origin distanceTo: aRectangle corner).
	corners := shape encompassingRectangle corners select: [ :each | 
		           aRectangle containsPoint: each ].
	segment := (corners collect: [ :each | 
		            | sg |
		            sg := OPRSAnchorConstraintSegment
			                  from: each
			                  to: each + vector.
		            OPRSAnchorConstraintSegment
			            from: each
			            to: (sg intersectRectangle: aRectangle) anyOne ]) 
		           detectMax: #length.
	segment ifNotNil: [ shape translateBy: segment vector ]
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> moveAwayFromSegment: aSegment [

	(aSegment intersectRectangle: shape encompassingRectangle)
		ifNotEmpty: [
			shape translateBy:
				aSegment vector normal * (distanceToLine + self extraDistance) ]
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> moveShape [

	shape translateTo: self anchorPoint.
	self moveShapeAwayFromCollisions
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> moveShapeAwayFromCollisions [

	| from to |
	self moveAwayFromSegment: self anchorSegment.
	from := line from encompassingRectangle expandBy:
		        minDistanceToLine abs.
	to := line to encompassingRectangle expandBy: minDistanceToLine abs.
	(shape encompassingRectangle intersects: from) ifTrue: [
		self moveAwayFrom: from via: self anchorSegment vector ].
	(shape encompassingRectangle intersects: to) ifTrue: [
		self moveAwayFrom: to via: self anchorSegment vector negated ]
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> nearestPointInfo [

	| currentNearest totalLengthFromStart |
	totalLengthFromStart := 0.
	currentNearest := OPRSAnchorConstraintNearestPoint new.
	currentNearest
		segment: self segments first;
		point: self segments first from;
		previousSegmentsLength: totalLengthFromStart.

	self segments do: [ :each | 
		| nearestPoint |
		nearestPoint := each nearestPointTo: shape position.
		(nearestPoint distanceTo: shape position)
		< (currentNearest distanceTo: shape position) ifTrue: [ 
			currentNearest
				segment: each;
				point: nearestPoint;
				previousSegmentsLength: totalLengthFromStart ].
		totalLengthFromStart := totalLengthFromStart + each length ].
	currentNearest lineLength: totalLengthFromStart.
	^ currentNearest
]

{ #category : #'as yet unclassified' }
OPRSAnchorConstraintUpdater >> nearestSegment [

	| segmentsWithDistances |
	segmentsWithDistances := self segments collect: [ :each | 
		                         each -> (each distanceTo: shape position) ].
	^ (segmentsWithDistances copyWithoutFirst
		   inject: segmentsWithDistances first
		   into: [ :nearest :current | 
			   current value < nearest value
				   ifTrue: [ current ]
				   ifFalse: [ nearest ] ]) key
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> positionReference [
	^ positionReference
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> positionReference: aConstraintReference [
	positionReference := aConstraintReference
]

{ #category : #accessing }
OPRSAnchorConstraintUpdater >> segments [

	^ segments ifNil: [ 
		  segments := line controlPoints overlappingPairsCollect: [ :a :b | 
			              OPRSAnchorConstraintSegment from: a to: b ] ]
]

{ #category : #building }
OPRSAnchorConstraintUpdater >> shape: aShape [

	shape := aShape
]

{ #category : #updating }
OPRSAnchorConstraintUpdater >> update [

	self moveAnchor.
	self moveShape
]
