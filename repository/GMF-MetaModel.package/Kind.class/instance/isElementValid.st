validating
isElementValid
	^ (parents
		anySatisfy: [:each | each parentClass isKindOf: MomentClass]) not & super isElementValid 