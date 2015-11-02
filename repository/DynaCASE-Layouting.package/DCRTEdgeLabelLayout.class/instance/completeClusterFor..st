as yet unclassified
completeClusterFor: aGraph
	| degrees removed |
	(self isComplete: aGraph)
		ifTrue: [ ^ {aGraph} ].
	degrees := aGraph nodes collect: [ :node | node -> (aGraph neighborNodesOf: node) size ].
	removed := (degrees detectMax: #value) key.
	aGraph edges removeAllSuchThat: [ :edge | edge from = removed | (edge to = removed) ].
	aGraph nodes remove: removed.
	^ self completeClustersFor: (self clusterGraphsFor: aGraph)