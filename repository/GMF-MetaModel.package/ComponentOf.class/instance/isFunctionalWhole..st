private
isFunctionalWhole: xElement

	(xElement isKindOf: SortalClass)
		ifTrue: [(xElement isMemberOf: Kind) | (xElement isMemberOf: SubKind)
					ifTrue: [^ super isElementValid ]].
	
	^ false