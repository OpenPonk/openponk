Class {
	#name : #OPControllerFactoryTest,
	#superclass : #TestCase,
	#instVars : [
		'factory'
	],
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #running }
OPControllerFactoryTest >> setUp [
	factory := OPControllerFactory new
]

{ #category : #tests }
OPControllerFactoryTest >> testNewControllerFor [
	factory register: OPTestRelationController forModel: OPTestRelationModel.
	self
		assert: (factory newControllerFor: OPTestRelationModel new) class
		equals: OPTestRelationController
]

{ #category : #tests }
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

{ #category : #tests }
OPControllerFactoryTest >> testRegister [
	self deny: (factory hasControllerFor: OPTestEntityModel new).
	factory register: OPTestEntityController forModel: OPTestEntityModel.
	self assert: (factory hasControllerFor: OPTestEntityModel new)
]
