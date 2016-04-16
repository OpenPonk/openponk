accessing
modelClass
	(self class includesSelector: #diagramClass)
		ifTrue: [ (Deprecation
				method: self class >> #diagramClass
				explanation: 'Please rename method #diagramClass to #modelClass in your Plugin definition.'
				on: 'unknown'
				in: 'unknown') signal.
			^ self diagramClass ].
	^ self subclassResponsibility