specs
isLinkInstalled
	^ self visitAst links ifNil: [ false ] ifNotNil: #isNotEmpty