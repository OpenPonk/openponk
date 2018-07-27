testing
representsModel: aModelClass
	figure ifNil: [ ^ false ].
	^ self model isKindOf: aModelClass