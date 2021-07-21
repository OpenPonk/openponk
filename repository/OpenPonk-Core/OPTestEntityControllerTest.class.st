Class {
	#name : #OPTestEntityControllerTest,
	#superclass : #OPBaseControllerTest,
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #accessing }
OPTestEntityControllerTest >> controllerClass [
	^ OPTestEntityController
]

{ #category : #accessing }
OPTestEntityControllerTest >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : #accessing }
OPTestEntityControllerTest >> diagramModelClass [
	^ OPTestContainerModel
]

{ #category : #accessing }
OPTestEntityControllerTest >> modelClass [
	^ OPTestEntityModel
]

{ #category : #'tests - connecting' }
OPTestEntityControllerTest >> testAddAsSourceAndTargetForRelation [
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

{ #category : #'tests - connecting' }
OPTestEntityControllerTest >> testAddAsSourceAndTargetForRelationToSelf [
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

{ #category : #'tests - connecting' }
OPTestEntityControllerTest >> testAddAsSourceForRelation [
	| relationController |
	relationController := diagramController
		newControllerFor: OPTestRelationModel new.
	controller addAsSourceFor: relationController.
	self assert: diagramController controllers asArray equals: {}.
	self assert: relationController source equals: controller
]

{ #category : #'tests - controllers' }
OPTestEntityControllerTest >> testAddController [
	controller model: model.
	diagramController addController: controller.
	self assert: (diagramController controllerForModel: model) equals: controller.
	self assert: controller diagramController equals: diagramController
]

{ #category : #'tests - connecting' }
OPTestEntityControllerTest >> testCanBeSourceForRelation [
	self
		assert:
			(controller
				canBeSourceFor: (diagramController newControllerFor: OPTestRelationModel new))
]

{ #category : #'tests - connecting' }
OPTestEntityControllerTest >> testCanBeTargetForRelation [
	self
		assert:
			(controller
				canBeTargetFor: (diagramController newControllerFor: OPTestRelationModel new))
]

{ #category : #'tests - construction' }
OPTestEntityControllerTest >> testCreateAndShow [
	| subModel |
	controller createModelIn: diagramController model andShowInDiagram: diagramController.
	self assert: diagramController model entities isNotEmpty.
	subModel := diagramController model entities first.
	self assert: diagramController controllers asArray equals: {controller}.
	self assert: (diagramController view elements includes: controller figure)
]

{ #category : #'tests - construction' }
OPTestEntityControllerTest >> testCreateModel [
	controller createModelIn: diagramController model.
	self assert: controller model isNotNil.
	self assert: diagramController model entities asArray equals: {controller model}
]

{ #category : #'tests - controllers' }
OPTestEntityControllerTest >> testFigureForModel [
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self assert: (diagramController figureForModel: model) equals: controller figure
]

{ #category : #'tests - construction' }
OPTestEntityControllerTest >> testFigureWasRendered [
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self assert: (diagramController view elements includes: controller figure)
]

{ #category : #'tests - controllers' }
OPTestEntityControllerTest >> testModelForFigure [
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self assert: (diagramController modelForFigure: controller figure) equals: model
]

{ #category : #'tests - controllers' }
OPTestEntityControllerTest >> testNewController [
	controller := diagramController newControllerFor: model.
	self assert: controller class equals: self controllerClass
]

{ #category : #'tests - ui interaction' }
OPTestEntityControllerTest >> testOpenInForm [
	| form |
	controller model: model.
	form := OPScrollableForm new.
	diagramController stub formPresenter willReturn: form.
	self assert: form widgets isEmpty.
	diagramController openInForm: controller.
	self assert: form widgets isNotEmpty
]

{ #category : #'tests - destruction' }
OPTestEntityControllerTest >> testRemoveController [
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	controller removeController.
	self should: [ diagramController controllerForModel: model ] raise: NotFound.
	self assert: diagramController view elements asArray equals: {}
]

{ #category : #'tests - destruction' }
OPTestEntityControllerTest >> testRemoveFigureAndModel [
	diagramController model entities add: model.
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	diagramController removeFromView: controller figure.
	self assert: diagramController controllers asArray equals: {}.
	self assert: diagramController model entities asArray equals: {}
]

{ #category : #'tests - construction' }
OPTestEntityControllerTest >> testShowInDiagram [
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self assert: (diagramController controllerForFigure: controller figure) equals: controller
]
