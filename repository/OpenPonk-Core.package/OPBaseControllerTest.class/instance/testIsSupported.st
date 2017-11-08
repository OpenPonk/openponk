tests
testIsSupported
	self diagramControllerClass = self controllerClass
		ifTrue: [ ^ self ].
	self assert: (diagramController hasSupportForModel: model)