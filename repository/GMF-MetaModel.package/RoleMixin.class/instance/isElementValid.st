validating
isElementValid
	^ (associations 
		anySatisfy: [:each | each isMemberOf: Mediation])
		& (roles size > 0) & super isElementValid