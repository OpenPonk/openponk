geometry
neighborsOf: aVertex
	^ (self edgesFor: aVertex)
		collect: [ :each | 
			each to = aVertex
				ifTrue: [ each from ]
				ifFalse: [ each to ] ]