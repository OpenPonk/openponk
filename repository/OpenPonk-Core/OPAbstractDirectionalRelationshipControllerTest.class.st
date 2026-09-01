"
Abstract base class for testing directional relationship controllers. 
Verifies the establishment of connections between source and target controllers, as well as the cascading behavior of element removals.
"
Class {
	#name : 'OPAbstractDirectionalRelationshipControllerTest',
	#superclass : 'OPAbstractElementControllerTest',
	#instVars : [
		'sourceModel',
		'targetModel',
		'targetController'
	],
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'testing' }
OPAbstractDirectionalRelationshipControllerTest class >> isAbstract [

	^ self = OPAbstractDirectionalRelationshipControllerTest
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> assignModelSource [

	model source: sourceModel
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> assignModelTarget [

	model target: targetModel
]

{ #category : 'constants' }
OPAbstractDirectionalRelationshipControllerTest >> creationTargetControllerClass [

	^ self sourceControllerClass
]

{ #category : 'constants' }
OPAbstractDirectionalRelationshipControllerTest >> creationTargetModelClass [

	^ self sourceModelClass
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> prepareToShow [

	controller source: self sourceController.
	controller target: self targetController.
	super prepareToShow
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> registerModel [

	super registerModel.
	self assignModelSource.
	self assignModelTarget
]

{ #category : 'running' }
OPAbstractDirectionalRelationshipControllerTest >> setUp [

	super setUp.
	self setUpTarget
]

{ #category : 'accessing' }
OPAbstractDirectionalRelationshipControllerTest >> setUpCreationTarget [

	self setUpSource
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> setUpCreationTargetController [

	self setUpSourceController
]

{ #category : 'accessing' }
OPAbstractDirectionalRelationshipControllerTest >> setUpCreationTargetModel [

	^ self setUpSourceModel
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> setUpSource [

	super setUpCreationTarget
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> setUpSourceController [

	^ super setUpCreationTargetController
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> setUpSourceModel [

	^ sourceModel := super setUpCreationTargetModel
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> setUpTarget [

	self setUpTargetController.
	self setUpTargetModel
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> setUpTargetController [

	targetController := self targetControllerClass new.
	targetController diagramController: diagramController
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> setUpTargetModel [

	^ targetModel := targetController createModelIn:
		                 diagramController model
]

{ #category : 'initialization' }
OPAbstractDirectionalRelationshipControllerTest >> showDependenciesInDiagram [

	super showDependenciesInDiagram.
	targetController showWithoutDependentInDiagram: diagramController
]

{ #category : 'accessing' }
OPAbstractDirectionalRelationshipControllerTest >> sourceController [

	^ creationTargetController
]

{ #category : 'constants' }
OPAbstractDirectionalRelationshipControllerTest >> sourceControllerClass [

	^ self subclassResponsibility
]

{ #category : 'constants' }
OPAbstractDirectionalRelationshipControllerTest >> sourceModelClass [

	^ self subclassResponsibility 
]

{ #category : 'accessing' }
OPAbstractDirectionalRelationshipControllerTest >> targetController [

	^ targetController
]

{ #category : 'constants' }
OPAbstractDirectionalRelationshipControllerTest >> targetControllerClass [

	^ self sourceControllerClass
]

{ #category : 'constants' }
OPAbstractDirectionalRelationshipControllerTest >> targetModelClass [

	^ self sourceModelClass
]

{ #category : 'tests - construction' }
OPAbstractDirectionalRelationshipControllerTest >> testCreateAndShow [

	| sourceController targetController |
	sourceController := diagramController newControllerFor:
		                    sourceModel.
	sourceController showWithoutDependentInDiagram: diagramController.
	targetController := diagramController newControllerFor:
		                    targetModel.
	targetController showWithoutDependentInDiagram: diagramController.
	controller source: sourceController.
	controller target: targetController.
	controller
		createModelIn: diagramController model
		andShowInDiagram: diagramController.
	self
		denyCollection: diagramController modelsWithController
		hasSameElements: {  }.
	self
		assertCollection: diagramController controllers
		includesAll: { controller }.
	self
		assertCollection: diagramController canvas lines
		includesAll: { controller roassalShape }
]

{ #category : 'tests - construction' }
OPAbstractDirectionalRelationshipControllerTest >> testCreateModel [

	| createdModel |
	self showDependenciesInDiagram.
	controller source: self sourceController.
	controller target: self targetController.
	createdModel := controller createModelIn: diagramController model.
	self assert: controller model isNotNil.
	self assert: createdModel equals: controller model.
	self
		assert: controller viewModel modelSource
		equals: self sourceController model.
	self
		assert: controller viewModel modelTarget
		equals: self targetController model
]

{ #category : 'tests' }
OPAbstractDirectionalRelationshipControllerTest >> testCreateUsingAddAsTarget [

	self showDependenciesInDiagram.
	self denyCollection: self allElements includesAll: { model }.
	self
		denyCollection: diagramController controllers
		includesAll: { controller }.
	self
		denyCollection: diagramController canvas shapes
		includesAll: { controller roassalShape }.
	self sourceController addAsSourceFor: controller.
	self targetController addAsTargetFor: controller.
	self deny: controller model equals: model.
	model := controller model.
	self assertCollection: self allElements includesAll: { model }.
	self
		assertCollection: diagramController controllers
		includesAll: { controller }.
	self
		assertCollection: diagramController canvas shapes
		includesAll: { controller roassalShape }.
	self
		assert: controller diagramElement class
		equals: self diagramElementClass
]

{ #category : 'tests' }
OPAbstractDirectionalRelationshipControllerTest >> testRemovalOfSourceRemovesRelationship [

	| roassalShape |
	self showInDiagram.
	roassalShape := controller roassalShape.
	self
		assertCollection: diagramController modelsWithController
		includesAll: { sourceModel }.
	self
		assertCollection: diagramController canvas edges
		includesAll: { roassalShape }.
	self
		assertCollection: diagramController modelsWithController
		includesAll: { model }.
	self sourceController removeControllerAndModel.
	self
		denyCollection: diagramController modelsWithController
		includesAll: { sourceModel }.
	self
		denyCollection: diagramController canvas edges
		includesAll: { roassalShape }.
	self
		denyCollection: diagramController modelsWithController
		includesAll: { model }
]

{ #category : 'tests - destruction' }
OPAbstractDirectionalRelationshipControllerTest >> testRemoveController [

	super testRemoveController.
	self
		denyCollection: diagramController canvas shapes
		hasSameElements: {  }
]

{ #category : 'tests - construction' }
OPAbstractDirectionalRelationshipControllerTest >> testRoassalShapeWasRendered [

	self showInDiagram.
	self assert:
		(diagramController canvas lines includes: controller roassalShape)
]

{ #category : 'tests' }
OPAbstractDirectionalRelationshipControllerTest >> testSetupOfTheTest [
	"tests mostly whether the creationTarget is really the same thing as source - in case it is not, it is probably fault of the test class itself"

	self
		assert: self creationTargetModelClass
		equals: self sourceModelClass.
	self
		assert: self creationTargetControllerClass
		equals: self sourceControllerClass.
	self
		assert: sourceModel class
		equals: creationTargetController model class
]
