hook
applyLayoutToEdges: aCollection
	| allEdges |
	allEdges := directed , undirected.
	aCollection
		do:
			[ :each | 
			| c e |
			e := allEdges at: (self indexFor: each).
			c := Color random.
			e shape router points: (self edgeLayoutToRoute: each).
			(self edgeLayoutToRoute: each)
				do:
					[ :p | 
					allEdges anyOne view
						add:
							((RTEllipse new
								color: c;
								element) translateTo: p) ].
			e
				update;
				signalUpdate ].
	allEdges anyOne view signalUpdate