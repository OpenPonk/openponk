"
Abstract base class for testing OpenPonk controllers. 
Provides basic scaffolding, initialization, and utility functions for testing controller subclasses.
"
Class {
	#name : 'OPBaseControllerTest',
	#superclass : 'TestCase',
	#instVars : [
		'controller',
		'model'
	],
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'testing' }
OPBaseControllerTest class >> isAbstract [
	^ self = OPBaseControllerTest
]

{ #category : 'accessing' }
OPBaseControllerTest >> controller [

	^ controller
]

{ #category : 'constants' }
OPBaseControllerTest >> controllerClass [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPBaseControllerTest >> controllersByModelsKey [

	^ self model
]

{ #category : 'accessing' }
OPBaseControllerTest >> model [

	^ model
]

{ #category : 'constants' }
OPBaseControllerTest >> modelClass [
	^ self subclassResponsibility
]

{ #category : 'initialization' }
OPBaseControllerTest >> newModel [

	^ self modelClass new
]

{ #category : 'running' }
OPBaseControllerTest >> setUp [

	super setUp.
	controller := self controllerClass new.
	model := self newModel
]

{ #category : 'tests' }
OPBaseControllerTest >> testViewModelClassModelClass [

	self
		assert: self controllerClass viewModelClass modelClass
		equals: self modelClass
]
