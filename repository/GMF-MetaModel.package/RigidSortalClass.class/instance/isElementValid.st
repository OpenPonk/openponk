validating
isElementValid
	^ (parents
		anySatisfy: [:each | (each parentClass isKindOf: AntiRigidSortalClass) 
				| ( each parentClass isKindOf: AntiRigidMixinClass)]) not & super isElementValid