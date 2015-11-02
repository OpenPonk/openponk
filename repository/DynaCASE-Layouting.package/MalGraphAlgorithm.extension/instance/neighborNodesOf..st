*DynaCASE-Layouting
neighborNodesOf: aNode
	^ self edges
		select: [ :anEdge | anEdge from model = aNode model | (anEdge to model = aNode model) ]
		thenCollect:
			[ :anEdge | 
			anEdge from = aNode
				ifTrue: [ anEdge to ]
				ifFalse: [ anEdge from ] ]