hook
findAssignmentFor: aMatchingGraph
	| matrix features clusters solver solution assignment |
	features := aMatchingGraph nodes select: #isFeature.
	clusters := aMatchingGraph nodes select: #isCluster.
	matrix := Matrix
		rows: features size
		columns: clusters size
		tabulate:
			[ :i :j | self costForFeature: (features at: i) cluster: (clusters at: j) edges: aMatchingGraph ].
	solver := DCRTLHungarianSolver new.
	solution := solver paddedSolve: matrix.
	assignment := (solution collect: #key)
		collect:
			[ :indices | 
			| feature cluster |
			feature := features at: indices first.
			cluster := clusters at: indices second.
			feature
				->
					(((cluster model nodes collect: #model)
						select: [ :pos | pos feature = (self labelForEdge: feature model) ])
						detectMin: [ :position | self penaltyForRanking: position of: feature model ]) ].
	^ assignment asDictionary