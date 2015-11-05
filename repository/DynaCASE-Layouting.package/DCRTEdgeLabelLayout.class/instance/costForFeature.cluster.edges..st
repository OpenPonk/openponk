as yet unclassified
costForFeature: aFeatureNode cluster: aClusterNode edges: matchingGraph
	^ matchingGraph edges
		detect: [ :e | e from = aFeatureNode & (e to = aClusterNode) ]
		ifFound:
			[ :e | 
			(e to model nodes
				select: [ :positionNode | positionNode model feature = (self labelForEdge: aFeatureNode model) ]
				thenCollect:
					[ :positionNode | 
					(self penaltyForRanking: positionNode model of: aFeatureNode model)
						+ (self penaltyForProximity: positionNode model of: aFeatureNode model) ]) min ]
		ifNone: [ Float infinity ]