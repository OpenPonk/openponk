validating
isElementValid	

	^ (self generalizations anySatisfy: [ :each | each parent isKindOf: RigidSortalClass ]) 
		& (self generalizations size > 0)
		& ((associations anySatisfy: [ :each | each isMemberOf: Mediation ]) 
			| (self generalizations anySatisfy: [ :parent | parent parent associations anySatisfy: [ :each | each isMemberOf: Mediation ] ]))
		& super isElementValid