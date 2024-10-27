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

	^ super allElements asSet copyWith: model
]

{ #category : 'tests - construction' }
OPDiagramOnlyControllerTest >> testCreateModel [
	"do nothing - there is no model"

	
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
	diagramElement := Mock new.
	diagramElement stub name willReturn: 'bravo'.
	controller diagramElement: diagramElement.
	controller descriptionName accessor write: 'charlie' to: controller.
	diagramElement should receive name: 'charlie'.
	self
		assert: (controller descriptionName accessor read: controller)
		equals: 'bravo'.
	diagramElement should receive modelChanged
]

{ #category : 'tests - destruction' }
OPDiagramOnlyControllerTest >> testRemoveModel [
	"do nothing - there is no model"
]
