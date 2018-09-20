accessing
modelType
	^ model
		ifNil: [ modelType ]
		ifNotNil: [ "NSP compat"
			(model respondsTo: #typeName)
				ifTrue: [ model typeName ]
				ifFalse: [ model class name ] ]