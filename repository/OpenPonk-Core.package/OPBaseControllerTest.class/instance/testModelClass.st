tests
testModelClass
	self diagramControllerClass = self controllerClass
		ifTrue: [ ^ self ].
	self assert: controller modelClass equals: self modelClass