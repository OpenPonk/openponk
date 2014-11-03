validating
isElementValid
	^ (parents
		anySatisfy: [:each | each parentClass isKindOf: RigidSortalClass]) not & super isElementValid 