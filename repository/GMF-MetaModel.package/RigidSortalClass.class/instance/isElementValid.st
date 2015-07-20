validating
isElementValid
	^ (self generalizations
		anySatisfy: [:each | (each parent isKindOf: AntiRigidSortalClass) 
				| ( each parent isKindOf: AntiRigidMixinClass)]) not & super isElementValid