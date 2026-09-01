"
Unit tests for OPDiagramController. 
Verifies the primary diagram loop, including element placement, sub-controller instantiation, and basic palette interactions.
"
Class {
	#name : 'OPDiagramControllerTest',
	#superclass : 'OPAbstractDiagramControllerTest',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'constants' }
OPDiagramControllerTest >> controllerClass [
	^ OPTestDiagramController
]

{ #category : 'accessing' }
OPDiagramControllerTest >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : 'accessing' }
OPDiagramControllerTest >> diagramModelClass [
	^ OPTestContainerModel
]

{ #category : 'constants' }
OPDiagramControllerTest >> modelClass [
	^ OPTestContainerModel
]

{ #category : 'tests - connecting' }
OPDiagramControllerTest >> testAddAsTargetForEntity [

	| entityController |
	entityController := controller newControllerFor:
		                    OPTestEntityModel new.
	controller addAsTargetFor: entityController.
	self
		assert: controller model entities asArray
		equals: { entityController model }.
	self
		assert: controller controllers asArray
		equals: { entityController }
]

{ #category : 'tests' }
OPDiagramControllerTest >> testAttachEditor [
	| editor form |
	editor := Mock new.
	form := Mock new.
	editor stub form willReturn: form.
	
	controller editor: editor.
	self assert: controller editor equals: editor.
	self assert: controller form equals: form
]

{ #category : 'tests - connecting' }
OPDiagramControllerTest >> testCanBeTargetForEntity [
	self
		assert:
			(controller
				canBeTargetFor: (controller newControllerFor: OPTestEntityModel new))
]

{ #category : 'tests - ui interaction' }
OPDiagramControllerTest >> testInitializePalette [

	| palette |
	palette := OPPalette new.
	self assert: palette items size equals: 2.
	controller initializePalette: palette.
	self assert: palette items size equals: 3
]

{ #category : 'tests' }
OPDiagramControllerTest >> testModelClass [
	| plugin pluginRegistry |
	plugin := OPPlugin new.
	plugin stub modelClass willReturn: self diagramModelClass.
	plugin stub diagramControllerClass willReturn: self diagramControllerClass.
	pluginRegistry := OPPluginRegistry new add: plugin.
	[ OPPluginRegistry setDefault: pluginRegistry.
	self assert: controller modelClass equals: self diagramModelClass ]
		ensure: [ OPPluginRegistry setDefault: nil ]
]

{ #category : 'tests - construction' }
OPDiagramControllerTest >> testShowModelInDiagram [

	| entity |
	controller model: model.
	entity := OPTestEntityModel new.
	controller showWithoutDependentInDiagramModel: entity
]

{ #category : 'tests - construction' }
OPDiagramControllerTest >> testShowModelInDiagramAttachesController [

	| entity |
	controller model: model.
	entity := OPTestEntityModel new.
	controller showWithoutDependentInDiagramModel: entity.
	self
		shouldnt: (controller controllerForModel: entity)
		raise: NotFound
]
