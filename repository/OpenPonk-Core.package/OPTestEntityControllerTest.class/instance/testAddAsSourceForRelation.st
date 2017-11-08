tests - connecting
testAddAsSourceForRelation
	| relationController |
	relationController := diagramController newControllerFor: OPTestRelationModel new.
	controller addAsSourceFor: relationController.
	self assert: diagramController controllers asArray equals: {}.
	self assert: relationController sourceController equals: controller.