validating
isElementValid
	| parts |
	self isExtensional
		ifTrue: [ parts := associations select: [ :each | (each isMemberOf: MemberOf) | (each isMemberOf: SubCollectionOf) ] ];
		ifFalse: [ ^ super isElementValid ].
		
	^ (parts allSatisfy: [ :each | each startMultiplicity ~= '0' ]) & super isElementValid 
	
     