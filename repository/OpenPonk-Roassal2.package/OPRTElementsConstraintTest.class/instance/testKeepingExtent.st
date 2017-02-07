tests
testKeepingExtent
	originShape extent: 10 @ 10.
	conformingShape extent: 20 @ 20.
	OPRTElementsConstraint keepExtentOf: conformingShape like: originShape plus: 5 @ -5.
	
	self assert: conformingShape extent = (15 @ 5).
	self assert: originShape extent = (10 @ 10).
	
	originShape extent: 0 @ 5.
	self assert: conformingShape extent = (5 @ 0)