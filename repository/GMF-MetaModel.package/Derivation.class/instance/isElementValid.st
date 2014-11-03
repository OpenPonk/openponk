validating
isElementValid
	((start isMemberOf: Relator) & (startMultiplicity ~= '1')) | ((end isMemberOf: Relator) & (endMultiplicity ~= '1')) 
		ifTrue: [ ^ false ].
	
	((start isMemberOf: MaterialAssociation) & ((startMultiplicity at: 1) = $0)) | ((end isMemberOf: MaterialAssociation) & ((endMultiplicity at: 1) = $0))
		ifTrue: [ ^ false ].
		
	((start isMemberOf: MaterialAssociation) & (end isMemberOf: Relator)) | ((start isMemberOf: Relator) & (end isMemberOf: MaterialAssociation))
		ifFalse: [ ^ false ].
		
	^ super isElementValid