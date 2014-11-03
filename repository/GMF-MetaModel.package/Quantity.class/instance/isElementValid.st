validating
isElementValid
	^ (associations allSatisfy: [:each | (each isMemberOf: FormalAssociation)
			| (each isMemberOf: SubQuantityOf)])
			& super isElementValid