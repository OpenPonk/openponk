tests - connecting
testAddAsTargetForEntity
	| entityController |
	entityController := diagramController newControllerFor: OPTestEntityModel new.
	diagramController addAsTargetFor: entityController.
	self assert: diagramController model entities asArray equals: {entityController model}.
	self assert: diagramController controllers asArray equals: {entityController}