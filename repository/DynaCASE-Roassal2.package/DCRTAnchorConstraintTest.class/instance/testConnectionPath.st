tests
testConnectionPath
	self
		assert: (connection shape pathFor: connection)
		equals:
			{(0 @ (source height / 2)).
			(0 @ 50).
			(50 @ 100).
			((100 - (target width / 2)) @ 100)}