tests
testInside
	| ap |
	el extent: 2000 @ 2000.
	self assert: (edgeX shape startingPointOf: edgeX) = (1000 @ 0).
	self assert: (edgeX shape endingPointOf: edgeX) = (110 @ 0).

	ap := edgeD shape startingPointOf: edgeD.
	self assert: -1000 @ -100 = ap | (-100 @ -1000 = ap).

	ap := edgeD shape endingPointOf: edgeD.
	self assert: -110 @ -100 = ap | (-100 @ -110 = ap)