accessing
modelClass
	(self class includesSelector: #diagramClass)
		ifTrue: [ ^ self diagramClass ].
	^ self subclassResponsibility