tests
testPath
	edge := OPRTStyledConnection new edgeFrom: from to: to.
	view add: edge.
	self
		assert: (edge shape pathFor: edge)
		equals: (Array with: from position with: to position).
	edge shape addPoint: 50 @ 100.
	self
		assert: (edge shape pathFor: edge)
		equals: (Array with: from position with: 50 @ 100 with: to position)