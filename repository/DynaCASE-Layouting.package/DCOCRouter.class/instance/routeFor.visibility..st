as yet unclassified
routeFor: anEdge visibility: visGraph
	| starts ends paths |
	starts := (self sideCentersFor: (anEdge from encompassingRectangle expandBy: 10))
		collect: [ :each | visGraph nodes detect: [ :node | node model = each ] ].
	ends := (self sideCentersFor: (anEdge to encompassingRectangle expandBy: 10))
		collect: [ :each | visGraph nodes detect: [ :node | node model = each ] ].
	paths := OrderedCollection new.
	starts
		do: [ :s | ends do: [ :e | paths add: (self routeFrom: s to: e visibility: visGraph) ] ].
	^ (paths detectMin: #length) route