validating
isElementValid
	^ (self generalizations
		anySatisfy: [:each | each parent isKindOf: SortalClass]) not & super isElementValid 