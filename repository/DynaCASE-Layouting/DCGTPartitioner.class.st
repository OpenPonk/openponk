"
I am the second phase of GT
"
Class {
	#name : #DCGTPartitioner,
	#superclass : #Object,
	#category : 'DynaCASE-Layouting-DGT'
}

{ #category : #'as yet unclassified' }
DCGTPartitioner >> independentSetFor: aGraph [
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
]

{ #category : #'as yet unclassified' }
DCGTPartitioner >> overlapGraphFor: aGraph ordering: anOrdering [
	| overlap one another a b c d tmp |
	overlap := DCGTGraph new.
	overlap nodes: (aGraph edges collect: [ :each | DCGTNode model: each ]).
	1 to: overlap nodes size do:
		[ :i | 
		one := overlap nodes at: i.
		tmp := Array
			with: (anOrdering indexOf: one model from)
			with: (anOrdering indexOf: one model to).
		a := tmp min.
		b := tmp max.
		i + 1 to: overlap nodes size do:
			[ :j | 
			another := overlap nodes at: j.
			tmp := Array
				with: (anOrdering indexOf: another model from)
				with: (anOrdering indexOf: another model to).
			c := tmp min.
			d := tmp max.
			a < c & (c < b) & (b < d) | (c < a & (a < d) & (d < b))
				ifTrue: [ overlap addEdge: (DCGTEdge from: one to: another) ] ] ].
	^ overlap
]

{ #category : #'as yet unclassified' }
DCGTPartitioner >> partition: aGraph ordering: anOrdering [
	| overlap left right rest |
	overlap := self overlapGraphFor: aGraph ordering: anOrdering.
	left := self independentSetFor: overlap.
	right := self
		independentSetFor: (overlap vertexInducedBy: (overlap nodes copyWithoutAll: left)).
	rest := overlap nodes copyWithoutAll: left , right.
	^ {left.
	right.
	rest}
]
