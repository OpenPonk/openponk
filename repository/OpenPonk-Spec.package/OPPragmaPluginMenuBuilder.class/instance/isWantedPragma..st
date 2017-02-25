testing
isWantedPragma: aPragma
	(self pragmaKeywords includes: aPragma keyword)
		ifFalse: [ ^ false ].
	aPragma selector numArgs = 1
		ifFalse: [ ^ false ].
	^ true