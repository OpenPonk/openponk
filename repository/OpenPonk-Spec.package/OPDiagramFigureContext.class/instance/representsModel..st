testing
representsModel: aModelClass
	figures ifEmpty: [ ^ false ].
	^ self models allSatisfy: [ :each | each isKindOf: aModelClass ]