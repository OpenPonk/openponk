tests
testClusterGraphFor
	| overlapGraph clusterGraph |
	true
		ifTrue: [ ^ self skip ].
	overlapGraph := layout overlapGraphFor: self positions.
	clusterGraph := layout clusterGraphsFor: overlapGraph.
	1 halt