validating
isElementValid
	^ (associations 
		select: [:each | each isMemberOf: Mediation]) size > 1 & super isElementValid