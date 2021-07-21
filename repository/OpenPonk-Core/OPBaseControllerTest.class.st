"
I provide basic scaffolding and utility functions to ease the testing of controllers.
"
Class {
	#name : #OPBaseControllerTest,
	#superclass : #TestCase,
	#instVars : [
		'controller',
		'diagramController',
		'model'
	],
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #testing }
OPBaseControllerTest class >> isAbstract [
	^ self = OPBaseControllerTest
]

{ #category : #accessing }
OPBaseControllerTest >> controllerClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPBaseControllerTest >> diagramControllerClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPBaseControllerTest >> diagramModelClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPBaseControllerTest >> modelClass [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
OPBaseControllerTest >> newModel [
	| aModel |
	aModel := self modelClass new.
	(aModel respondsTo: #name:)
		ifTrue: [ aModel name: self modelClass name asString ].
	^ aModel
]

{ #category : #running }
OPBaseControllerTest >> setUp [
	super setUp.
	controller := self controllerClass new.
	diagramController := self diagramControllerClass new.
	diagramController model: self diagramModelClass new.
	diagramController view: RTView new.
	model := self newModel
]

{ #category : #support }
OPBaseControllerTest >> stubRefresh [
	controller stub figure willReturn: Mock new.
	controller stub refreshFigure willReturn: controller
]

{ #category : #tests }
OPBaseControllerTest >> testBuildEditorForm [
	self skip.
	"| form |
	form := OPDynamicForm new.
	controller model: model.
	self shouldnt: [ controller buildEditorForm: form ] raise: Error"
]

{ #category : #tests }
OPBaseControllerTest >> testIsSupported [
	self diagramControllerClass = self controllerClass
		ifTrue: [ ^ self ].
	self assert: (diagramController hasSupportForModel: model)
]

{ #category : #tests }
OPBaseControllerTest >> testModelClass [
	self diagramControllerClass = self controllerClass
		ifTrue: [ ^ self ].
	self assert: controller modelClass equals: self modelClass
]
