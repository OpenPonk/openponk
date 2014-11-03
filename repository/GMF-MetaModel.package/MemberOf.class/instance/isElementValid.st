validating
isElementValid
	( end isMemberOf: Collective )
		ifFalse: [ ^ false ].
	( end isExtensional & self isEssential not ) 
		ifTrue: [ ^ false ].
	
	^ super isElementValid