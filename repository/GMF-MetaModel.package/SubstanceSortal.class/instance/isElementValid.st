validating
isElementValid
	^ (self generalizations
		anySatisfy: [:each | each parent isKindOf: RigidSortalClass]) not & super isElementValid 