Class {
	#name : #OPTestRelationControllerTest,
	#superclass : #OPBaseControllerTest,
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #accessing }
OPTestRelationControllerTest >> controllerClass [
	^ OPTestRelationController
]

{ #category : #accessing }
OPTestRelationControllerTest >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : #accessing }
OPTestRelationControllerTest >> diagramModelClass [
	^ OPTestContainerModel
]

{ #category : #accessing }
OPTestRelationControllerTest >> modelClass [
	^ OPTestRelationModel
]

{ #category : #'tests - controllers' }
OPTestRelationControllerTest >> testAddController [
	controller model: model.
	diagramController addController: controller.
	self assert: (diagramController controllerForModel: model) equals: controller.
	self assert: controller diagramController equals: diagramController
]

{ #category : #'tests - construction' }
OPTestRelationControllerTest >> testCreateAndShow [
	| subModel sourceController targetController |
	sourceController := diagramController
		newControllerFor: OPTestEntityModel new.
	sourceController showWithoutDependentInDiagram: diagramController.
	targetController := diagramController
		newControllerFor: OPTestEntityModel new.
	targetController showWithoutDependentInDiagram: diagramController.
	controller source: sourceController.
	controller target: targetController.
	controller
		createModelIn: diagramController model
		andShowInDiagram: diagramController.
	self assert: diagramController model entities isNotEmpty.
	subModel := diagramController model entities first.
	self assert: (diagramController controllers includes: controller).
	self
		assert: (diagramController view elements includes: controller figure)
]

{ #category : #'tests - construction' }
OPTestRelationControllerTest >> testCreateModel [
	| sourceController targetController |
	sourceController := diagramController
		newControllerFor: OPTestEntityModel new.
	sourceController showWithoutDependentInDiagram: diagramController.
	targetController := diagramController
		newControllerFor: OPTestEntityModel new.
	targetController showWithoutDependentInDiagram: diagramController.
	controller source: sourceController.
	controller target: targetController.
	controller createModelIn: diagramController model.
	self assert: controller model isNotNil.
	self assert: controller model source equals: sourceController model.
	self assert: controller model target equals: targetController model
]

{ #category : #'tests - controllers' }
OPTestRelationControllerTest >> testFigureForModel [
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self assert: (diagramController figureForModel: model) equals: controller figure
]

{ #category : #'tests - construction' }
OPTestRelationControllerTest >> testFigureWasRendered [
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self assert: (diagramController view elements includes: controller figure)
]

{ #category : #'tests - controllers' }
OPTestRelationControllerTest >> testModelForFigure [
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self assert: (diagramController modelForFigure: controller figure) equals: model
]

{ #category : #'tests - controllers' }
OPTestRelationControllerTest >> testNewController [
	controller := diagramController newControllerFor: model.
	self assert: controller class equals: self controllerClass
]

{ #category : #'tests - ui interaction' }
OPTestRelationControllerTest >> testOpenInForm [
	| form |
	controller model: model.
	form := OPScrollableForm new.
	diagramController stub formPresenter willReturn: form.
	self assert: form widgets isEmpty.
	diagramController openInForm: controller.
	self assert: form widgets isNotEmpty
]

{ #category : #'tests - destruction' }
OPTestRelationControllerTest >> testRemoveController [
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	controller removeController.
	self should: [ diagramController controllerForModel: model ] raise: NotFound.
	self assert: diagramController view elements asArray equals: {}
]

{ #category : #'tests - destruction' }
OPTestRelationControllerTest >> testRemoveFigureAndModel [
	diagramController model entities add: model.
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	diagramController removeFromView: controller figure.
	self assert: diagramController controllers asArray equals: {}.
	self assert: diagramController model entities asArray equals: {}
]

{ #category : #'tests - construction' }
OPTestRelationControllerTest >> testShowInDiagram [
	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self assert: (diagramController controllerForFigure: controller figure) equals: controller
]
