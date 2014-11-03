validating
isElementValid
	^ self isSharable = false & self isEssential = true & startMultiplicity = '1'
		& (start isMemberOf: Quantity)
		& (end isMemberOf: Quantity) & super isElementValid 