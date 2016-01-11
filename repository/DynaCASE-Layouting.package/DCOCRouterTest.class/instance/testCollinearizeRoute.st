tests
testCollinearizeRoute
	self
		assert: (router class collinearizeRoute: {0@0 . 10@0 . 10@10 . 10@20 . 30@20 . 50 @ 20 . 50 @ 40})
		equals: {0@0 . 10@0 . 10@20 . 50 @ 20 . 50 @ 40}