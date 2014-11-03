validating
isElementValid
	^ (associations
		allSatisfy: [:each | each isMemberOf: Characterization])
		& (associations size > 0) & super isElementValid