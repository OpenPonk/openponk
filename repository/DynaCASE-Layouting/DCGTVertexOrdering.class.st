"
Basic vertex ordering for undirected graphs.
"
Class {
	#name : 'DCGTVertexOrdering',
	#superclass : 'DCGTAbstractVertexOrdering',
	#category : 'DynaCASE-Layouting-DGT',
	#package : 'DynaCASE-Layouting',
	#tag : 'DGT'
}

{ #category : 'as yet unclassified' }
DCGTVertexOrdering >> firstVertexFor: aGraph [
	| minDeg |
	minDeg := (aGraph nodes collect: #inDegree) min.
	^ (aGraph nodes select: [ :each | each inDegree = minDeg ]) detectMin: #outDegree
]

{ #category : 'as yet unclassified' }
DCGTVertexOrdering >> orderingFor: aGraph [
	| d rcl v perm graph |
	graph := aGraph.
	perm := OrderedCollection new.
	d := (graph vertices collect: [ :each | graph degreeFor: each ]) min.
	rcl := graph vertices select: [ :each | (graph degreeFor: each) = d ].
	perm add: rcl anyOne.
	v := graph vertices copyWithout: perm last.
	graph := graph vertexInducedBy: v.
	1 to: v size do:
		[ :k | 
		d := (graph vertices collect: [ :each | graph degreeFor: each ]) min.
		(graph neighborsOf: v last)
			ifNotEmpty: [ :adj | rcl := adj select: [ :each | (graph degreeFor: each) = d ] ]
			ifEmpty: [ rcl := v select: [ :each | (graph degreeFor: each) = d ] ].
		perm add: rcl anyOne.
		v := graph vertices copyWithout: perm last.
		graph := graph vertexInducedBy: v ].
	^ perm
]
