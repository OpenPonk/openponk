tests
testSegmentWithPointRelative
	| segment segments |
	segment := RTLineSegment from: 0 @ 0 to: 8 @ 6.
	segments := OPRTPolyLineSegment with: segment.
	self assert: (segments segmentWithPointFor: 0) equals: (Array with: segment with: 0 @ 0).
	self assert: (segments segmentWithPointFor: 0.5) equals: (Array with: segment with: 4 @ 3).
	self assert: (segments segmentWithPointFor: 1) equals: (Array with: segment with: 8 @ 6)