comparing
= xAssociation
	(xAssociation isKindOf: ElementAssociation)
		ifFalse: [ ^ false ].
		
	^ self name = xAssociation name & ( (self start = xAssociation start) | (self start = xAssociation end) ) & ( self end = xAssociation start | self end = xAssociation end )