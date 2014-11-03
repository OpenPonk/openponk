validating
isElementValid
	^ ((start isMemberOf: Relator)
		| end isMemberOf: Relator)
		& (endMultiplicity at:1) ~= $0 & (startMultiplicity at:1) ~= $0 & super isElementValid 