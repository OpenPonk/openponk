as yet unclassified
independentSetFor: aGraph
	| set graph v |
	set := OrderedCollection new.
	graph := aGraph vertexInducedBy: aGraph nodes copy.
	[ graph nodes isNotEmpty ]
		whileTrue:
			[ v := graph nodes detectMin: [ :each | graph degreeFor: each ].
			set add: v.
			graph := graph
				vertexInducedBy: (graph nodes copyWithoutAll: {v} , (graph neighborsOf: v)) ].
	^ set