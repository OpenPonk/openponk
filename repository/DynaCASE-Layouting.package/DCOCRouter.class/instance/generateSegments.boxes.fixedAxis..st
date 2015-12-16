as yet unclassified
generateSegments: aGraph boxes: boxes fixedAxis: anAxis
	| fixed lines seg otherAxis |
	otherAxis := anAxis = #x
		ifTrue: [ #y ]
		ifFalse: [ #x ].
	fixed := (aGraph nodes collect: [ :each | anAxis value: each model ] as: Set) sorted.
	lines := fixed
		collect: [ :fix | aGraph nodes select: [ :each | (anAxis value: each model) = fix ] ].
	lines := lines
		collect: [ :each | each sorted: [ :a :b | (otherAxis value: a model) < (otherAxis value: b model) ] ].
	lines
		do:
			[ :line | 
			line
				overlappingPairsDo:
					[ :a :b | 
					seg := RTLineSegment from: a model to: b model.
					boxes
						detect: [ :box | (seg intersectRectangle: box) isNotEmpty ]
						ifNone: [ aGraph addEdge: (DCGTEdge from: a to: b) ] ] ]