validating
isElementValid
	^ (derivated isMemberOf: Derivation) & ((startMultiplicity at:1) ~= $0) & ((endMultiplicity at:1) ~= $0) & super isElementValid 