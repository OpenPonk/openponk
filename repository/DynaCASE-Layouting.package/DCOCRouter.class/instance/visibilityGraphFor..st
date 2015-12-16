as yet unclassified
visibilityGraphFor: elements
	| boundaries i xi yi boxes nodes graph |
	boxes := elements collect: [ :each | each encompassingRectangle expandBy: 9 ].
	boundaries := self interestingPointsFor: elements.
	i := (boundaries flatCollect: #value) asSet.
	xi := i collect: #x.
	yi := i collect: #y.
	nodes := (xi flatCollect: [ :x | yi collect: [ :y | x @ y ] ])
		select:
			[ :each | boxes detect: [ :box | box containsPoint: each ] ifFound: [ false ] ifNone: [ true ] ].
	graph := DCGTGraph new.
	graph nodes: (nodes collect: [ :each | DCOCNode on: each ]).
	graph nodes
		do:
			[ :each | 
			boundaries
				do: [ :b | b value detect: [ :bPoint | each model = bPoint ] ifFound: [ each element: b key ] ] ].
	self generateSegments: graph boxes: boxes.
	^ graph