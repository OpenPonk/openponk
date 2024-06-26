"
I provide basic scaffolding and utility functions to ease the testing of controllers.
"
Class {
	#name : 'OPBaseControllerTest',
	#superclass : 'TestCase',
	#instVars : [
		'controller',
		'diagramController',
		'model'
	],
	#category : 'OpenPonk-Core-Controllers - Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers - Tests'
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
OPBaseControllerTest >> diagramControllerClass [
	^ self subclassResponsibility
]

{ #category : 'construction' }
OPBaseControllerTest >> diagramElementClass [

	^ OPTestDiagramElement
]

{ #category : 'accessing' }
OPBaseControllerTest >> diagramModelClass [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPBaseControllerTest >> modelClass [
	^ self subclassResponsibility
]

{ #category : 'instance creation' }
OPBaseControllerTest >> newModel [

	| aModel |
	aModel := self modelClass new.
	(aModel respondsTo: #name:) ifTrue: [ 
		aModel name: self modelClass name asString ].
	^ aModel
]

{ #category : 'running' }
OPBaseControllerTest >> setUp [

	super setUp.
	controller := self controllerClass new.
	diagramController := self diagramControllerClass new.
	diagramController model: self diagramModelClass new.
	diagramController canvasPresenter: (OPCanvasPresenter new
			 canvas: RSCanvas new;
			 yourself).
	model := self newModel
]

{ #category : 'support' }
OPBaseControllerTest >> stubRefresh [
	controller stub figure willReturn: Mock new.
	controller stub refreshFigure willReturn: controller
]

{ #category : 'tests' }
OPBaseControllerTest >> testIsSupported [
	self diagramControllerClass = self controllerClass
		ifTrue: [ ^ self ].
	self assert: (diagramController hasSupportForModel: model)
]
