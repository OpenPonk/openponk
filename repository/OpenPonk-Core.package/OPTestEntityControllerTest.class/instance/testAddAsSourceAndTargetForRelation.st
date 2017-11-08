tests - connecting
testAddAsSourceAndTargetForRelation
	| sourceModel targetModel relationController relationModel |
	sourceModel := self newModel.
	targetModel := self newModel.
	diagramController model entities
		add: sourceModel;
		add: targetModel.
	diagramController showAllElements.
	relationController := diagramController newControllerFor: OPTestRelationModel new.
	(diagramController controllerForModel: sourceModel) addAsSourceFor: relationController.
	(diagramController controllerForModel: targetModel) addAsTargetFor: relationController.
	relationModel := relationController model.
	self assert: (diagramController controllers includes: relationController).
	self
		assert: diagramController model entities asArray
		equals: (Array with: sourceModel with: targetModel with: relationModel).
	self assert: relationModel source equals: sourceModel.
	self assert: relationModel target equals: targetModel