initialization
neighborsOf: anElement
	^ (anElement connectedEdges
		collect: [ :each | 
			each to = anElement
				ifTrue: [ each from ]
				ifFalse: [ each to ] ]) removeDuplicates