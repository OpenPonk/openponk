Class {
	#name : 'OPAbstractDirectionalRelationshipControllerTest',
	#superclass : 'OPAbstractElementControllerTest',
	#instVars : [
		'sourceModel',
		'targetModel'
	],
	#category : 'OpenPonk-Core-Controllers - Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers - Tests'
}

{ #category : 'testing' }
OPAbstractDirectionalRelationshipControllerTest class >> isAbstract [

	^ self = OPAbstractDirectionalRelationshipControllerTest
]

{ #category : 'running' }
OPAbstractDirectionalRelationshipControllerTest >> addModelToDiagramModel [

	self addToDiagramModel: model
]

{ #category : 'running' }
OPAbstractDirectionalRelationshipControllerTest >> addSourceToDiagramModel [

	self addToDiagramModel: sourceModel
]

{ #category : 'running' }
OPAbstractDirectionalRelationshipControllerTest >> addTargetToDiagramModel [

	self addToDiagramModel: targetModel
]

{ #category : 'running' }
OPAbstractDirectionalRelationshipControllerTest >> addToDiagramModel: aModel [

	diagramController model add: aModel
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> assignModelSource [

	model source: sourceModel
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> assignModelTarget [

	model target: targetModel
]

{ #category : 'accessing' }
OPAbstractDirectionalRelationshipControllerTest >> creationTargetControllerClass [

	^ self sourceControllerClass
]

{ #category : 'accessing' }
OPAbstractDirectionalRelationshipControllerTest >> creationTargetModelClass [

	^ self sourceModelClass
]

{ #category : 'running' }
OPAbstractDirectionalRelationshipControllerTest >> setUp [

	super setUp.
	sourceModel := self sourceModelClass new.
	targetModel := self targetModelClass new.
	self assignModelSource.
	self assignModelTarget.
	self addSourceToDiagramModel.
	self addTargetToDiagramModel.
	self addModelToDiagramModel
]

{ #category : 'as yet unclassified' }
OPAbstractDirectionalRelationshipControllerTest >> sourceControllerClass [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPAbstractDirectionalRelationshipControllerTest >> sourceModelClass [

	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
OPAbstractDirectionalRelationshipControllerTest >> targetControllerClass [

	^ self sourceControllerClass
]

{ #category : 'accessing' }
OPAbstractDirectionalRelationshipControllerTest >> targetModelClass [

	^ self sourceModelClass
]

{ #category : 'tests - controllers' }
OPAbstractDirectionalRelationshipControllerTest >> testAddController [
	controller model: model.
	diagramController addController: controller.
	self assert: (diagramController controllerForModel: model) equals: controller.
	self assert: controller diagramController equals: diagramController
]

{ #category : 'tests - construction' }
OPAbstractDirectionalRelationshipControllerTest >> testCreateAndShow [

	| subModel sourceController targetController |
	sourceController := diagramController newControllerFor:
		                    OPTestEntityModel new.
	sourceController showWithoutDependentInDiagram: diagramController.
	targetController := diagramController newControllerFor:
		                    OPTestEntityModel new.
	targetController showWithoutDependentInDiagram: diagramController.
	controller source: sourceController.
	controller target: targetController.
	controller
		createModelIn: diagramController model
		andShowInDiagram: diagramController.
	self assert: diagramController model entities isNotEmpty.
	subModel := diagramController model entities first.
	self assert: (diagramController controllers includes: controller).
	self assert:
		(diagramController canvas lines includes: controller roassalShape)
]

{ #category : 'tests - construction' }
OPAbstractDirectionalRelationshipControllerTest >> testCreateModel [
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

{ #category : 'tests - controllers' }
OPAbstractDirectionalRelationshipControllerTest >> testFigureForModel [

	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self
		assert: (diagramController roassalShapeForModel: model)
		equals: controller roassalShape
]

{ #category : 'tests - construction' }
OPAbstractDirectionalRelationshipControllerTest >> testFigureWasRendered [

	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self assert:
		(diagramController canvas lines includes: controller roassalShape)
]

{ #category : 'tests - controllers' }
OPAbstractDirectionalRelationshipControllerTest >> testModelForFigure [

	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self
		assert:
		(diagramController modelForFigure: controller roassalShape)
		equals: model
]

{ #category : 'tests - controllers' }
OPAbstractDirectionalRelationshipControllerTest >> testNewController [
	controller := diagramController newControllerFor: model.
	self assert: controller class equals: self controllerClass
]

{ #category : 'tests - ui interaction' }
OPAbstractDirectionalRelationshipControllerTest >> testOpenInForm [

	| form |
	controller model: model.
	form := OPDynamicForm new.
	diagramController stub form willReturn: form.
	self assert: form layout children isEmpty.
	diagramController openInForm: controller.
	self assert: form layout children isNotEmpty
]

{ #category : 'tests - destruction' }
OPAbstractDirectionalRelationshipControllerTest >> testRemoveController [

	controller model: model.
	self assert: diagramController canvas shapes size equals: 0.
	controller showWithoutDependentInDiagram: diagramController.

	self assert: diagramController canvas shapes size equals: 3.
	controller removeController.
	self
		should: [ diagramController controllerForModel: model ]
		raise: NotFound.
	self assert: diagramController canvas shapes size equals: 2
]

{ #category : 'tests - destruction' }
OPAbstractDirectionalRelationshipControllerTest >> testRemoveFigureAndModel [

	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self assert: diagramController model entities size equals: 3.
	self assert: diagramController canvas shapes size equals: 3.
	diagramController removeModelOfRoassalShape: controller roassalShape.
	self assert: diagramController controllers size equals: 2.

	self assert: diagramController model entities size equals: 2.
	self assert: diagramController canvas shapes size equals: 2
]

{ #category : 'tests - construction' }
OPAbstractDirectionalRelationshipControllerTest >> testShowInDiagram [

	controller model: model.
	controller showWithoutDependentInDiagram: diagramController.
	self
		assert:
		(diagramController controllerForRoassalShape:
			 controller roassalShape)
		equals: controller
]
