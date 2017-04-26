testing
isWantedPragma: aPragma
	(self pragmaKeywords includes: aPragma keyword)
		ifFalse: [ ^ false ].
	aPragma methodSelector numArgs = 1
		ifFalse: [ ^ false ].
	^ true