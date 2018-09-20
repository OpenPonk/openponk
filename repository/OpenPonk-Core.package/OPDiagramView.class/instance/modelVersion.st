accessing
modelVersion
	^ model
		ifNil: [ modelVersion ]
		ifNotNil: [ "NSM compat"
			(model respondsTo: #version)
				ifTrue: [ model version ]
				ifFalse: [ nil ] ]