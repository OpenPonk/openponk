as yet unclassified
testNoCollision
	self assert: (edgeX shape startingPointOf: edgeX) = (10 @ 0).
	self assert: (edgeX shape endingPointOf: edgeX) = (90 @ 0).
	self assert: (edgeD shape startingPointOf: edgeD) = (-10 @ -10).
	self assert: (edgeD shape endingPointOf: edgeD) = (-90 @ -90)