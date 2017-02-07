tests
testChangingExtent
	
	OPRTElementsConstraint changeExtentOf: conformingShape like: originShape plus: 5 @ -5.
	self assert: conformingShape extent = (15 @ 5).
	self assert: originShape extent = (10 @ 10).
	
	originShape extent: 0 @ 0.
	self assert: conformingShape extent = (15 @ 5).
	
	OPRTElementsConstraint changeExtentOf: conformingShape like: originShape plus: 0 @ 0.
	self assert: conformingShape extent = (0 @ 0)