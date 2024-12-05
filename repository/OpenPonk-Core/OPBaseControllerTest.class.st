"
I provide basic scaffolding and utility functions to ease the testing of controllers.
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

{ #category : 'accessing' }
OPBaseControllerTest >> modelClass [
	^ self subclassResponsibility
]

{ #category : 'instance creation' }
OPBaseControllerTest >> newModel [

	^ self modelClass new
]

{ #category : 'running' }
OPBaseControllerTest >> setUp [

	super setUp.
	controller := self controllerClass new.
	model := self newModel
]
