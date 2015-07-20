validating
isElementValid
	^ (self generalizations 
		anySatisfy: [:each | each parent isKindOf: AntiRigidMixinClass]) not & super isElementValid