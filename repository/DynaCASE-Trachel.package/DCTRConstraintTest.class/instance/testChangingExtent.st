tests
testChangingExtent
	originShape extent: 10 @ 10.
	conformingShape extent: 20 @ 20.
	DCTRConstraint changeExtentOf: conformingShape like: originShape plus: 5 @ -5.
	self assert: conformingShape extent = (15 @ 5).
	self assert: originShape extent = (10 @ 10).
	originShape extent: 0 @ 0.
	self assert: conformingShape extent = (15 @ 5).
	DCTRConstraint changeExtentOf: conformingShape like: originShape plus: 0 @ 0.
	self assert: conformingShape extent = (0 @ 0)