accessing
modelClass
	(Deprecation
		method: self class >> #diagramClass
		explanation: 'Please rename method #diagramClass to #modelClass in your Plugin definition.'
		on: 'unknown'
		in: 'unknown') signal.
	^ self subclassResponsibility