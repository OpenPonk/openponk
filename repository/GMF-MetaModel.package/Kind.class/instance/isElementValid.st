validating
isElementValid
	^ (self generalizations
		anySatisfy: [:each | each parent isKindOf: MomentClass]) not & super isElementValid 