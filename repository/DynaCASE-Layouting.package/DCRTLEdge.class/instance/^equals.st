comparing
= anEdge
	self species = anEdge species
		ifFalse: [ ^ false ].
	^ self from = anEdge from & (self to = anEdge to)