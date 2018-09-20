"
I take a graph and produce a collection of (noncomplete) connected clusters.
"
Class {
	#name : #DCRTLClusters,
	#superclass : #Object,
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels'
}

{ #category : #'as yet unclassified' }
DCRTLClusters >> clusterGraphsFor: anOverlapGraph [
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
								detect: [ :edge | edge from = neighbor & (edge to = node) ]
								ifNone: [ graph addEdge: (DCRTLEdge with: 'P to P' from: node to: neighbor) ] ] ].
			graph ]
]

{ #category : #'as yet unclassified' }
DCRTLClusters >> clustersFor: anOverlapGraph [
	| classGraph clusters |
	(classGraph := MalGraphStructure new).
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
					(clusters at: node) addAll: ((clusters at: neighbor) copyWithoutAll: (clusters at: node)).
					clusters at: neighbor put: (clusters at: node) ] ].
	^ ((clusters values asOrderedCollection do: #removeDuplicates) collect: #asArray)
		removeDuplicates asArray
]

{ #category : #'as yet unclassified' }
DCRTLClusters >> completeClusterFor: aGraph [
	| degrees removed |
	(self isComplete: aGraph)
		ifTrue: [ ^ {aGraph} ].
	degrees := aGraph nodes collect: [ :node | node -> (aGraph neighborNodesOf: node) size ].
	removed := (degrees detectMax: #value) key.
	aGraph edges removeAllSuchThat: [ :edge | edge from = removed | (edge to = removed) ].
	aGraph nodes remove: removed.
	^ self completeClustersFor: (self clusterGraphsFor: aGraph)
]

{ #category : #'as yet unclassified' }
DCRTLClusters >> completeClustersFor: clusterGraphs [
	^ clusterGraphs flatCollect: [ :each | self completeClusterFor: each ]
]

{ #category : #'as yet unclassified' }
DCRTLClusters >> isComplete: aGraph [
	"|E| = |N|*(|N|-1)/2"

	^ aGraph edges size = (aGraph nodes size * (aGraph nodes size - 1) / 2)
]
