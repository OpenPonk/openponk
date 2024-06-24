Class {
	#name : 'OPElementControllerTest',
	#superclass : 'OPAbstractElementControllerTest',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'accessing' }
OPElementControllerTest >> controllerClass [
	^ OPTestEntityController
]

{ #category : 'accessing' }
OPElementControllerTest >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : 'construction' }
OPElementControllerTest >> diagramElementClass [

	^ OPTestDiagramElement
]

{ #category : 'accessing' }
OPElementControllerTest >> diagramModelClass [
	^ OPTestContainerModel
]

{ #category : 'accessing' }
OPElementControllerTest >> modelClass [
	^ OPTestEntityModel
]

{ #category : 'tests - connecting' }
OPElementControllerTest >> testAddAsSourceAndTargetForRelation [

	| sourceModel targetModel relationController relationModel |
	sourceModel := self newModel.
	targetModel := self newModel.
	diagramController model
		add: sourceModel;
		add: targetModel.
	diagramController showAllElements.
	relationController := diagramController newControllerFor:
		                      OPTestRelationModel new.
	(diagramController controllerForModel: sourceModel) addAsSourceFor:
		relationController.
	(diagramController controllerForModel: targetModel) addAsTargetFor:
		relationController.
	relationModel := relationController model.
	self
		assertCollection: diagramController controllers
		includesAll: { relationController }.
	self
		assertCollection: diagramController model entities asArray
		hasSameElements: {
				sourceModel.
				targetModel.
				relationModel }.
	self assert: relationModel source equals: sourceModel.
	self assert: relationModel target equals: targetModel
]

{ #category : 'tests - connecting' }
OPElementControllerTest >> testAddAsSourceAndTargetForRelationToSelf [
	| relationController relationModel |
	controller model: model.
	diagramController model add: model.
	controller showWithoutDependentInDiagram: diagramController.
	relationController := diagramController
		newControllerFor: OPTestRelationModel new.
	controller addAsSourceFor: relationController.
	controller addAsTargetFor: relationController.
	relationModel := relationController model.
	self
		assertCollection: diagramController controllers asSet
		equals:
			{controller.
			relationController} asSet.
	self
		assertCollection: diagramController model entities asSet
		equals:
			{model.
			relationModel} asSet.
	self assert: relationModel source equals: model.
	self assert: relationModel target equals: model
]

{ #category : 'tests - connecting' }
OPElementControllerTest >> testAddAsSourceForRelation [
	| relationController |
	relationController := diagramController
		newControllerFor: OPTestRelationModel new.
	controller addAsSourceFor: relationController.
	self assert: diagramController controllers asArray equals: {}.
	self assert: relationController source equals: controller
]

{ #category : 'tests - connecting' }
OPElementControllerTest >> testCanBeSourceForRelation [
	self
		assert:
			(controller
				canBeSourceFor: (diagramController newControllerFor: OPTestRelationModel new))
]

{ #category : 'tests - connecting' }
OPElementControllerTest >> testCanBeTargetForRelation [
	self
		assert:
			(controller
				canBeTargetFor: (diagramController newControllerFor: OPTestRelationModel new))
]
