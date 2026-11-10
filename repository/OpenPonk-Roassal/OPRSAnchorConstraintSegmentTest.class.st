"
Verifies geometric calculations, equality, point projections, and rectangle intersections of line segments used by anchor constraints.
"
Class {
	#name : 'OPRSAnchorConstraintSegmentTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests',
	#package : 'OpenPonk-Roassal',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPRSAnchorConstraintSegmentTest >> testEqualityAndHash [
	| segmentA segmentB segmentC |
	segmentA := OPRSAnchorConstraintSegment from: 10 @ 20 to: 30 @ 40.
	segmentB := OPRSAnchorConstraintSegment from: 10 @ 20 to: 30 @ 40.
	segmentC := OPRSAnchorConstraintSegment from: 10 @ 20 to: 30 @ 50.
	self assert: segmentA equals: segmentB.
	self assert: segmentA hash equals: segmentB hash.
	self deny: segmentA equals: segmentC.
	self deny: segmentA equals: 'not a segment'
]

{ #category : 'tests' }
OPRSAnchorConstraintSegmentTest >> testExtremaAndVectorAndLength [
	| segment |
	segment := OPRSAnchorConstraintSegment from: 10 @ 50 to: 40 @ 10.
	self assert: segment left equals: 10 @ 50.
	self assert: segment right equals: 40 @ 10.
	self assert: segment bottom equals: 40 @ 10.
	self assert: segment top equals: 10 @ 50.
	self assert: segment vector equals: 30 @ -40.
	self assert: segment length equals: 50.
	self assert: segment cotan equals: (30 / -40).
	self assert: segment transposed equals: (OPRSAnchorConstraintSegment from: 50 @ 10 to: 10 @ 40)
]

{ #category : 'tests' }
OPRSAnchorConstraintSegmentTest >> testHorizontalCotanAndPointAtLength [
	| horizontal zeroSegment |
	horizontal := OPRSAnchorConstraintSegment from: 0 @ 10 to: 100 @ 10.
	self assert: horizontal cotan equals: nil.
	self assert: (horizontal pointAtLength: 25) equals: 25 @ 10.
	self assert: (horizontal pointAtLength: -10) equals: 0 @ 10.
	self assert: (horizontal pointAtLength: 250) equals: 100 @ 10.
	zeroSegment := OPRSAnchorConstraintSegment new.
	self assert: (zeroSegment pointAtLength: 10) equals: 0 @ 0
]

{ #category : 'tests' }
OPRSAnchorConstraintSegmentTest >> testIntersectRectangle [
	| diagonal horizontal rect intersections |
	rect := 20 @ 20 corner: 80 @ 60.
	diagonal := OPRSAnchorConstraintSegment from: 0 @ 40 to: 100 @ 40.
	intersections := diagonal intersectRectangle: rect.
	self assertCollection: intersections hasSameElements: { 20 @ 40 . 80 @ 40 }.
	horizontal := OPRSAnchorConstraintSegment from: 50 @ 0 to: 50 @ 100.
	self
		assertCollection: (horizontal intersectRectangle: rect)
		hasSameElements: { 50 @ 20 . 50 @ 60 }
]

{ #category : 'tests' }
OPRSAnchorConstraintSegmentTest >> testSideOfPointAndNearestPoint [
	| segment nearestPoint |
	segment := OPRSAnchorConstraintSegment from: 0 @ 0 to: 100 @ 0.
	self assert: (segment sideOfPoint: 50 @ -20) equals: -1.
	self assert: (segment sideOfPoint: 50 @ 0) equals: 0.
	self assert: (segment sideOfPoint: 50 @ 20) equals: 1.
	self assert: (segment nearestPointTo: 40 @ 30) equals: 40 @ 0.
	nearestPoint := OPRSAnchorConstraintNearestPoint new
		segment: segment;
		point: 40 @ 0;
		previousSegmentsLength: 20;
		lineLength: 120;
		yourself.
	self assert: nearestPoint lengthFromSegmentStart equals: 40.
	self assert: nearestPoint lengthFromLineStart equals: 60.
	self assert: nearestPoint balance equals: 0.5.
	self assert: (nearestPoint distanceTo: 40 @ 15) equals: 15.
	self assert: (nearestPoint sideOfPoint: 40 @ 15) equals: 1.
	self assert: (nearestPoint distanceToRectangle: (30 @ 10 corner: 50 @ 30)) equals: 10.
	self assert: (nearestPoint distanceAlongLineToRectangle: (30 @ 10 corner: 50 @ 30)) equals: 10
]
