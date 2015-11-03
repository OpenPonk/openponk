as yet unclassified
overlapGraphFor: aDictionary
	| graph oldGraph positions added |
	(graph := MalGraphStructure new) edgeClass: MalGraphEdge.
	oldGraph := DCRTLBipartiteGraph new.
	positions := OrderedCollection new.
	aDictionary
		keysAndValuesDo:
			[ :label :positionNodes | 
			| e featureNode |
			e := self edgeForLabel: label.
			featureNode := DCRTLFeatureNode with: e.
			graph addNode: featureNode.
			graph addNodes: positionNodes.
			positions addAll: positionNodes.
			positionNodes
				do:
					[ :node | graph addEdge: (DCRTLEdge with: 'F to L' from: featureNode to: node) ] ].
	added := Set new.
	positions
		do:
			[ :a | 
			positions
				select: [ :b | a ~= b & (a model bounds intersects: b model bounds) & (added includes: b -> a) not ]
				thenDo:
					[ :b | 
					graph addEdge: (DCRTLEdge with: 'L to L' from: a to: b).
					added add: a -> b ] ].
	^ graph