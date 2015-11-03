tests
testClusterGraphFor
	| overlapGraph clusterGraph |
	overlapGraph := layout overlapGraphFor: self positions.
	clusterGraph := layout clusterGraphsFor: overlapGraph.
	1halt.