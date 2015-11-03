as yet unclassified
costForFeature: aFeatureNode cluster: aClusterNode edges: someEdges
	^ someEdges
		detect: [ :e | (e from = aFeatureNode & e to) = aClusterNode ]
		ifFound:
			[ :e | 
			(e to model nodes
				collect:
					[ :positionNode | 
					(self penaltyForRanking: positionNode model)
						+ (self penaltyForProximity: positionNode model to: aFeatureNode model) ]) min ]
		ifNone: [ Float infinity ]