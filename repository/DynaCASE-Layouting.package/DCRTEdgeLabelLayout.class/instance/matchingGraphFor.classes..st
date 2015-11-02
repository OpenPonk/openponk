as yet unclassified
matchingGraphFor: anOverlapGraph classes: clusterGraphs
	| matchingGraph clusterNode |
	matchingGraph := MalGraphStructure new.
	anOverlapGraph nodes select: #isFeature thenDo: [ :node | matchingGraph addNode: node ].
	clusterGraphs
		do:
			[ :each | 
			clusterNode := DCRTLClusterNode with: each.
			matchingGraph addNode: clusterNode.
			each nodes
				do:
					[ :node | 
					((anOverlapGraph neighborNodesOf: node) select: #isFeature)
						do:
							[ :feature | 
							matchingGraph edges
								detect: [ :edge | edge from = feature & (edge to = clusterNode) ]
								ifNone:
									[ matchingGraph addEdge: (DCRTLEdge with: 'F to C' from: feature to: clusterNode) ] ] ] ].
	^ matchingGraph