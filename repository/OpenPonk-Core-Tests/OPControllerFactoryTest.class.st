"
Unit tests for OPControllerFactory. 
Verifies the registration, lookup, and instantiation of controllers based on provided model instances and types.
"
Class {
	#name : 'OPControllerFactoryTest',
	#superclass : 'TestCase',
	#instVars : [
		'factory'
	],
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'running' }
OPControllerFactoryTest >> setUp [
	| project projectController diagramController |
	super setUp.
	project := OPProject new.
	projectController := OPProjectController forProject: project.
	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	factory := OPControllerFactory new.
	factory diagramController: diagramController
]

{ #category : 'tests' }
OPControllerFactoryTest >> testNewControllerFor [
	factory register: OPTestRelationController forModel: OPTestRelationModel.
	self
		assert: (factory newControllerFor: OPTestRelationModel new) class
		equals: OPTestRelationController
]

{ #category : 'tests' }
OPControllerFactoryTest >> testNewControllerForWithPriority [
	factory
		register: OPTestEntityController
		forModel: OPTestRelationModel
		condition: [ :aModel | aModel source isNotNil ].
	factory register: OPTestRelationController forModel: OPTestRelationModel.
	self
		assert: (factory newControllerFor: OPTestRelationModel new) class
		equals: OPTestRelationController.
	self
		assert: (factory newControllerFor: (OPTestRelationModel new source: 12)) class
		equals: OPTestEntityController
]

{ #category : 'tests' }
OPControllerFactoryTest >> testRegister [
	self
		deny: (factory hasControllerFor: OPTestEntityModel new)
		description: 'Factory should not have controller before registration'.
	factory register: OPTestEntityController forModel: OPTestEntityModel.
	self
		assert: (factory hasControllerFor: OPTestEntityModel new)
		description: 'Factory should have controller after registering OPTestEntityController'
]
