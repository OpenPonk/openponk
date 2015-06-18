validating
isElementValid
	^ (self generalizationSets anySatisfy: [:each | each disjoint & each complete])
			& super isElementValid 