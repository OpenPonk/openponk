tests
testOverlapGraphFor
	| graph |
	graph := layout overlapGraphFor: self positions.
	self assert: graph nodes size equals: 3.
	self assert: (graph nodes select: #isFeature) size equals: 1.
	self assert: (graph nodes select: #isPosition) size equals: 2.
	self assert: graph edges size equals: 2