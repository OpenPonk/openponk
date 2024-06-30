Class {
	#name : 'OPElementControllerTest',
	#superclass : 'OPAbstractElementControllerTest',
	#category : 'OpenPonk-Core-Controllers - Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers - Tests'
}

{ #category : 'accessing' }
OPElementControllerTest >> controllerClass [
	^ OPTestEntityController
]

{ #category : 'accessing' }
OPElementControllerTest >> diagramControllerClass [
	^ OPTestDiagramController
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
	relationController := diagramController
		newControllerFor: OPTestRelationModel new.
	(diagramController controllerForModel: sourceModel)
		addAsSourceFor: relationController.
	(diagramController controllerForModel: targetModel)
		addAsTargetFor: relationController.
	relationModel := relationController model.
	self
		assert: (diagramController controllers includes: relationController).
	self
		assert: diagramController model entities asArray
		equals: (Array with: sourceModel with: targetModel with: relationModel).
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

{ #category : 'tests - controllers' }
OPElementControllerTest >> testAddController [
	controller model: model.
	diagramController addController: controller.
	self assert: (diagramController controllerForModel: model) equals: controller.
	self assert: controller diagramController equals: diagramController
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

{ #category : 'tests - construction' }
OPElementControllerTest >> testCreateAndShow [

	| subModel |
	controller
		createModelIn: diagramController model
		andShowInDiagram: diagramController.
	self assert: diagramController model entities isNotEmpty.
	subModel := diagramController model entities first.
	self
		assert: diagramController controllers asArray
		equals: { controller }.
	self assert:
		(diagramController canvas nodes includes: controller roassalShape)
]

{ #category : 'tests - construction' }
OPElementControllerTest >> testCreateModel [
	controller createModelIn: diagramController model.
	self assert: controller model isNotNil.
	self assert: diagramController model entities asArray equals: {controller model}
]

{ #category : 'tests - controllers' }
OPElementControllerTest >> testFigureForModel [

	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self
		assert: (diagramController roassalShapeForModel: model)
		equals: controller roassalShape
]

{ #category : 'tests - construction' }
OPElementControllerTest >> testFigureWasRendered [

	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self assert:
		(diagramController canvas nodes includes: controller roassalShape)
]

{ #category : 'tests - controllers' }
OPElementControllerTest >> testModelForFigure [

	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self
		assert:
		(diagramController modelForFigure: controller roassalShape)
		equals: model
]

{ #category : 'tests - controllers' }
OPElementControllerTest >> testNewController [
	controller := diagramController newControllerFor: model.
	self assert: controller class equals: self controllerClass
]

{ #category : 'tests - ui interaction' }
OPElementControllerTest >> testOpenInForm [

	| form |
	controller model: model.
	form := OPDynamicForm new.
	diagramController stub form willReturn: form.
	self assert: form layout children isEmpty.
	diagramController openInForm: controller.
	self assert: form layout children isNotEmpty
]

{ #category : 'tests - destruction' }
OPElementControllerTest >> testRemoveController [

	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	controller removeController.
	self
		should: [ diagramController controllerForModel: model ]
		raise: NotFound.
	self assert: diagramController canvas nodes asArray equals: {  }
]

{ #category : 'tests - destruction' }
OPElementControllerTest >> testRemoveFigureAndModel [

	diagramController model entities add: model.
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	diagramController removeModelOfRoassalShape: controller roassalShape.
	self assert: diagramController controllers asArray equals: {  }.
	self assert: diagramController model entities asArray equals: {  }
]

{ #category : 'tests - construction' }
OPElementControllerTest >> testShowInDiagram [

	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self
		assert: (diagramController controllerForRoassalShape:
				 controller roassalShape)
		equals: controller
]
