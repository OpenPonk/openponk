tests
testPath2
	from translateTo: 0 @ 0.
	to translateTo: 100 @ 0.
	edge := DCRTStyledConnection new
		attachPoint: DCRTNewRectangleAttachPoint new;
		edgeFrom: from to: to.
	view add: edge.
	self
		assert: (edge shape pathFor: edge)
		equals:
			{(from position + ((from width / 2) @ 0)).
			(to position - ((to width / 2) @ 0))}