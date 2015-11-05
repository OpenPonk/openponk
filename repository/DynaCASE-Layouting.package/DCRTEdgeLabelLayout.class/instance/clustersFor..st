as yet unclassified
clustersFor: anOverlapGraph
	| classGraph clusters |
	(classGraph := MalGraphStructure new) edgeClass: MalGraphEdge.
	anOverlapGraph nodes
		select: #isPosition
		thenDo:
			[ :node | 
			classGraph
				addNode:
					(DCRTLPositionNode new
						model: node model;
						index: node index;
						yourself) ].
	anOverlapGraph edges
		select: [ :edge | edge from isPosition & edge to isPosition ]
		thenDo:
			[ :edge | 
			classGraph
				addEdge:
					(DCRTLEdge
						with: edge model
						from: (classGraph findNode: edge from model)
						to: (classGraph findNode: edge to model)) ].
	clusters := OrderedDictionary new.
	classGraph nodes do: [ :node | clusters at: node put: {node} asOrderedCollection ].
	classGraph nodes
		do:
			[ :node | 
			(classGraph neighborNodesOf: node)
				do:
					[ :neighbor | 
					(clusters at: node) addAll: (clusters at: neighbor).
					clusters at: neighbor put: (clusters at: node) ] ].
	^ ((clusters values asOrderedCollection do: #removeDuplicates) collect: #asArray)
		removeDuplicates asArray