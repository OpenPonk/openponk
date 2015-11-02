as yet unclassified
clusterGraphsFor: anOverlapGraph
	| clusters graph |
	clusters := self clustersFor: anOverlapGraph.
	^ clusters
		collect:
			[ :cluster | 
			graph := MalGraphStructure new.
			graph addNodes: cluster.
			cluster
				do:
					[ :node | 
					((anOverlapGraph neighborNodesOf: node) intersection: cluster)
						do:
							[ :neighbor | 
							graph edges
								detect: [ :edge | (edge from = neighbor & edge to) = node ]
								ifNone: [ graph addEdge: (DCRTLEdge with: 'P to P' from: node to: neighbor) ] ] ].
			graph ]