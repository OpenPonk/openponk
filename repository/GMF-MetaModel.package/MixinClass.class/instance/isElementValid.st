validating
isElementValid
	^ (parents
		anySatisfy: [:each | each parentClass isKindOf: SortalClass]) not & super isElementValid 