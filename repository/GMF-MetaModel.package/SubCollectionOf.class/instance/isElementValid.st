validating
isElementValid
	^ startMultiplicity = '1'
		& (start isMemberOf: Collective)
		& (end isMemberOf: Collective) & super isElementValid