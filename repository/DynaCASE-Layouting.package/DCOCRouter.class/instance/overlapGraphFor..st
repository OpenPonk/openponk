as yet unclassified
overlapGraphFor: routes
	| overlapGraph nodesLookup candidates |
	overlapGraph := DCGTGraph new.
	candidates := Dictionary new.
	nodesLookup := Dictionary new.
	routes
		withIndexDo:
			[ :route :i | 
			route
				overlappingPairsDo: [ :a :b | (candidates at: (a corner: b) ifAbsentPut: [ OrderedCollection new ]) add: i ] ].
	candidates associations
		select: [ :pair | pair value size > 1 ]
		thenDo:
			[ :pair | 
			nodesLookup at: pair key origin ifAbsentPut: [ DCOCNode on: pair key origin ].
			nodesLookup at: pair key corner ifAbsentPut: [ DCOCNode on: pair key corner ].
			overlapGraph
				addEdge:
					((DCOCOverlapEdge
						from: (nodesLookup at: pair key origin)
						to: (nodesLookup at: pair key corner)) routes: pair value) ].
	overlapGraph nodes: nodesLookup values.
	^ overlapGraph