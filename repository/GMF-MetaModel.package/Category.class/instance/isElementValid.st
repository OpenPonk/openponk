validating
isElementValid
	^ (subObjects
		allSatisfy: [:each | each isKindOf: SortalClass]) 
		& subObjects size > 0 & super isElementValid