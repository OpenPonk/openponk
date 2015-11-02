comparing
= aNode
	self species = aNode species
		ifFalse: [ ^ false ].
	^ self model = aNode model