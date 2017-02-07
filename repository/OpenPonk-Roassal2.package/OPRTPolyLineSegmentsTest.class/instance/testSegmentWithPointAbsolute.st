tests
testSegmentWithPointAbsolute
	| segments |
	segments := OPRTPolyLineSegment
		with: (RTLineSegment from: 0 @ 0 to: 8 @ 6)
		with: (RTLineSegment from: 8 @ 6 to: 16 @ 0).
	self
		assert: (segments segmentWithPointFor: 5)
		equals: (Array with: segments first with: 4 @ 3).
	self
		assert: (segments segmentWithPointFor: 10)
		equals: (Array with: segments first with: 8 @ 6).
	self
		assert: (segments segmentWithPointFor: 15)
		equals: (Array with: segments second with: 12 @ 3).
	self
		assert: (segments segmentWithPointFor: 20)
		equals: (Array with: segments second with: 16 @ 0)