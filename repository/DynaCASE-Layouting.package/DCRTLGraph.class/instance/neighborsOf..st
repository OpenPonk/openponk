as yet unclassified
neighborsOf: aNode
	^ edges
		select: [ :pair | pair key = aNode | (pair value = aNode) ]
		thenCollect: [ :pair | 
			pair key = aNode
				ifTrue: [ pair value ]
				ifFalse: [ pair key ] ]