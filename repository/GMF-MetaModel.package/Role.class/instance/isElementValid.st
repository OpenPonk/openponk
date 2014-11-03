validating
isElementValid	

	^ (parents anySatisfy: [ :each | each parentClass isKindOf: RigidSortalClass ]) 
		& (parents size > 0)
		& ((associations anySatisfy: [ :each | each isMemberOf: Mediation ]) 
			| (parents anySatisfy: [ :parent | parent parentClass associations anySatisfy: [ :each | each isMemberOf: Mediation ] ]))
		& super isElementValid