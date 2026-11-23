"
Unit tests for verifying core functionality of OPElementController subclasses, such as acting as sources or targets for connecting relationships.
"
Class {
	#name : 'OPElementControllerTest',
	#superclass : 'OPAbstractElementControllerTest',
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'constants' }
OPElementControllerTest class >> diagramElementClass [

	^ OPTestDiagramElement
]

{ #category : 'constants' }
OPElementControllerTest >> controllerClass [
	^ OPTestEntityController
]

{ #category : 'constants' }
OPElementControllerTest >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : 'constants' }
OPElementControllerTest >> diagramModelClass [

	^ OPTestContainerModel
]

{ #category : 'constants' }
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
	relationController := diagramController newControllerFor:
		                      OPTestRelationModel new.
	controller addAsSourceFor: relationController.
	controller addAsTargetFor: relationController.
	relationModel := relationController model.
	self assertCollection: diagramController controllers asSet equals: {
			controller.
			relationController } asSet.
	self
		assertCollection: diagramController model entities asSet
		equals: {
				model.
				relationModel } asSet.
	self assert: relationModel source equals: model.
	self assert: relationModel target equals: model
]

{ #category : 'tests - connecting' }
OPElementControllerTest >> testAddAsSourceForRelation [

	| relationController |
	relationController := diagramController newControllerFor: OPTestRelationModel new.
	controller addAsSourceFor: relationController.
	self assertEmpty: diagramController controllers.
	self assert: relationController source equals: controller
]

{ #category : 'tests' }
OPElementControllerTest >> testCanBeSourceForRelation [
	self
		assert: (controller canBeSourceFor: (diagramController newControllerFor: OPTestRelationModel new))
		description: 'Entity controller should be a valid source for relation controller'
]

{ #category : 'tests' }
OPElementControllerTest >> testCanBeTargetForRelation [
	self
		assert: (controller canBeTargetFor: (diagramController newControllerFor: OPTestRelationModel new))
		description: 'Entity controller should be a valid target for relation controller'
]

{ #category : 'tests' }
OPElementControllerTest >> testOwnerAndIntendedOwningModelSkipHiddenIntermediateParent [

	| intermediateContainer nestedEntity nestedController |
	intermediateContainer := OPTestContainerModel new.
	nestedEntity := OPTestEntityModel new.
	diagramController model add: intermediateContainer.
	intermediateContainer add: nestedEntity.
	nestedController := diagramController newControllerFor: nestedEntity.
	self assert: nestedController intendedModelOfOwningDiagramElement identicalTo: diagramController model.
	self assert: nestedController owner identicalTo: diagramController
]

{ #category : 'tests' }
OPElementControllerTest >> testOwnerReturnsDirectParentController [

	diagramController model add: model.
	controller model: model.
	self assert: controller owner identicalTo: diagramController
]

{ #category : 'tests' }
OPElementControllerTest >> testOwnerReturnsNilWhenNoAncestorHasController [

	| foreignContainer foreignEntity foreignController |
	foreignContainer := OPTestContainerModel new.
	foreignEntity := OPTestEntityModel new.
	foreignContainer add: foreignEntity.
	diagramController project addModel: foreignContainer.
	foreignController := diagramController newControllerFor: foreignEntity.
	self assert: foreignController owner identicalTo: nil
]

{ #category : 'tests' }
OPElementControllerTest >> testUpdateAfterDiagramFocusedSkipsUnrenderedController [

	controller model: model.
	self deny: controller isRendered description: 'Controller should not be rendered before showing in diagram'.
	controller updateAfterDiagramFocused.
	self deny: controller isRendered description: 'updateAfterDiagramFocused must leave an unrendered controller unrendered'
]
