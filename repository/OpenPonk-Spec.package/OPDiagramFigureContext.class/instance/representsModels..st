testing
representsModels: aCollection
	figures ifEmpty: [ ^ false ].
	^ self models allSatisfy: [ :each | aCollection anySatisfy: [ :cls | each isKindOf: cls ] ]