as yet unclassified
overlapGraphFor: aGraph ordering: anOrdering
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