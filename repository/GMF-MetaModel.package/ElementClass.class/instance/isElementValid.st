validating
isElementValid
	| meronymic |
	"if is attribute isSharable in meronymic association true the part can be join to more than one whole"
	meronymic := associations select: [ :each | ((each isKindOf: Meronymic) & (each start = self)) ].
	
	( meronymic anySatisfy: [ :each | each isSharable = false ] ) & (meronymic size > 1)
		ifTrue: [ ^ false ].
		
	^ super isElementValid