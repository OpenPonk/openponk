tests - connecting
testAddAsSourceAndTargetForRelationToSelf
	| relationController relationModel |
	controller model: model.
	diagramController model entities add: model.
	controller showInDiagram: diagramController.
	relationController := diagramController newControllerFor: OPTestRelationModel new.
	controller addAsSourceFor: relationController.
	controller addAsTargetFor: relationController.
	relationModel := relationController model.
	self
		assert: diagramController controllers asArray
		equals:
			{controller.
			relationController}.
	self
		assert: diagramController model entities asArray
		equals:
			{model.
			relationModel}.
	self assert: relationModel source equals: model.
	self assert: relationModel target equals: model