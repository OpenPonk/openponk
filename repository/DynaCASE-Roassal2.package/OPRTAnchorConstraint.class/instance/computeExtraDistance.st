as yet unclassified
computeExtraDistance
	"Compute the extra distance required to move the element to not overlap the segment."

	| segment sideOfElement normals |
	segment := self anchorSegment first.
	sideOfElement := segment sideOfPoint: element position.
	normals := element encompassingRectangle corners
		select: [ :each | (segment sideOfPoint: each) ~= sideOfElement ]
		thenCollect: [ :each | each dist: (each nearestPointAlongLineFrom: segment from to: segment to) ].
	^ minDistance sign > 0
		ifTrue: [ normals max ]
		ifFalse: [ normals max negated ]