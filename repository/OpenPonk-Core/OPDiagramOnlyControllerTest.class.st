"
Abstract base class for testing diagram-only element controllers (e.g., notes and boundaries) that do not possess a distinct domain model mapping.
"
Class {
	#name : 'OPDiagramOnlyControllerTest',
	#superclass : 'OPAbstractElementControllerTest',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'testing' }
OPDiagramOnlyControllerTest class >> isAbstract [

	^ self = OPDiagramOnlyControllerTest
]

{ #category : 'accessing' }
OPDiagramOnlyControllerTest >> allElements [

	^ super allElements copyWith: self model
]

{ #category : 'accessing' }
OPDiagramOnlyControllerTest >> controllersByModelsKey [

	^ self diagramElementClass new
]

{ #category : 'accessing' }
OPDiagramOnlyControllerTest >> model [

	^ controller ifNotNil: [ :ctrl | ctrl diagramElement ]
]

{ #category : 'constants' }
OPDiagramOnlyControllerTest >> modelClass [

	^ self diagramElementClass
]

{ #category : 'initialization' }
OPDiagramOnlyControllerTest >> newModel [

	^ nil
]

{ #category : 'initialization' }
OPDiagramOnlyControllerTest >> registerModel [
	"do nothing"

	
]

{ #category : 'tests' }
OPDiagramOnlyControllerTest >> testBeingRemovedAfterModelRemovalWhenNotRendered [
	| diagram diagramElement |
	self showInDiagram.
	diagram := diagramController diagramElement.
	diagramElement := controller diagramElement.
	self
		assert: controller isDiagramOnly
		description: 'Controller should be diagram-only'.
	self assertCollection: diagram allOwnedElements includesAll: { diagramElement }.
	controller removeModel.
	self assert: controller model identicalTo: diagramElement.
	self assertCollection: diagram allOwnedElements includesAll: { diagramElement }
]

{ #category : 'tests' }
OPDiagramOnlyControllerTest >> testBeingRemovedAfterModelRemovalWhenRendered [
	self showInDiagram.
	self assertCollection: diagramController controllers includesAll: { controller }.
	controller removeModel.
	diagramController diagramFocused.
	self assertCollection: diagramController controllers includesAll: { controller }.
	controller removeControllerAndDiagramElement.
	self denyCollection: diagramController controllers includesAny: { controller }
]

{ #category : 'tests' }
OPDiagramOnlyControllerTest >> testCreateModel [
	| createdModel |
	createdModel := controller createModelIn: creationTargetController model.
	self deny: createdModel identicalTo: nil.
	self assert: createdModel identicalTo: controller diagramElement.
	self assert: controller model identicalTo: controller diagramElement.
	self assert: createdModel class equals: self diagramElementClass
]

{ #category : 'tests' }
OPDiagramOnlyControllerTest >> testCreateUsingAddAsTarget [

	self showDependenciesInDiagram.
	self
		denyCollection: diagramController controllers
		includesAll: { controller }.
	self
		denyCollection: diagramController canvas shapes
		includesAll: { controller roassalShape }.
	creationTargetController addAsTargetFor: controller.
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
OPDiagramOnlyControllerTest >> testDescriptionName [

	| diagramElement |
	diagramElement := self diagramElementClass new.
	diagramElement stub name willReturn: 'bravo'.

	controller model: diagramElement.

	controller viewModel descriptionName accessor
		write: 'charlie'
		to: controller.
	diagramElement should receive name: 'charlie'.
	self
		assert:
		(controller viewModel descriptionName accessor read: controller)
		equals: 'bravo'.
	diagramElement should receive modelChanged
]

{ #category : 'tests' }
OPDiagramOnlyControllerTest >> testHideUndoRedo [
	self testCreateUsingAddAsTarget.
	self
		deny: controller isHideable
		description: 'Diagram-only controller should not be hideable'
]

{ #category : 'tests - destruction' }
OPDiagramOnlyControllerTest >> testRemoveModel [
	self showInDiagram.
	self deny: controller diagramElement identicalTo: nil.
	controller removeModel.
	self assert: controller model identicalTo: controller diagramElement.
	self assertCollection: diagramController controllers includesAll: { controller }
]

{ #category : 'tests' }
OPDiagramOnlyControllerTest >> testRemoveUndoRedo [
	| undoManager createdModel |
	self testCreateUsingAddAsTarget.
	undoManager := diagramController undoManager.
	createdModel := controller model.

	diagramController removeModelElement: createdModel.
	self
		deny: (diagramController hasControllerForModel: createdModel)
		description: 'Diagram-only element should not have a controller after removal'.

	undoManager undo.
	self
		assert: (diagramController hasControllerForModel: createdModel)
		description: 'Diagram-only element should have a controller after undo'.

	undoManager redo.
	self
		deny: (diagramController hasControllerForModel: createdModel)
		description: 'Diagram-only element should not have a controller after redo'.

	undoManager undo.
	self
		assert: (diagramController hasControllerForModel: createdModel)
		description: 'Diagram-only element should have a controller after second undo'
]

{ #category : 'tests' }
OPDiagramOnlyControllerTest >> testShowUndoRedo [
	self testCreateUsingAddAsTarget.
	self
		deny: controller isHideable
		description: 'Diagram-only controller should not be hideable'
]
