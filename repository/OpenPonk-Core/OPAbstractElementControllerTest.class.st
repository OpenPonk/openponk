Class {
	#name : 'OPAbstractElementControllerTest',
	#superclass : 'OPBaseControllerTest',
	#instVars : [
		'creationTargetController'
	],
	#category : 'OpenPonk-Core-Controllers - Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers - Tests'
}

{ #category : 'testing' }
OPAbstractElementControllerTest class >> isAbstract [

	^ self = OPAbstractElementControllerTest
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> creationTargetControllerClass [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> creationTargetModelClass [
	^ self subclassResponsibility
]

{ #category : 'running' }
OPAbstractElementControllerTest >> setUp [
	super setUp.
	self setUpCreationTarget
]

{ #category : 'accessing' }
OPAbstractElementControllerTest >> setUpCreationTarget [
	creationTargetController := self creationTargetControllerClass new.
	creationTargetController diagramController: diagramController.
	creationTargetController createModelIn: diagramController model
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testClassSideModelClass [

	self assert: self controllerClass modelClass equals: self modelClass
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testCreateController [
	self assert: controller class equals: self controllerClass
]

{ #category : 'tests - creation' }
OPAbstractElementControllerTest >> testCreateDiagramElement [

	self diagramControllerClass = self controllerClass ifTrue: [ 
		self skip ].
	self class = OPAbstractElementControllerTest ifTrue: [ self skip ].

	controller model: model.
	controller diagramController: diagramController.
	controller ensureShownDependenciesInDiagram: diagramController.
	controller createDiagramElement.
	self
		assert: controller diagramElement class
		equals: self diagramElementClass
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testDescriptionName [
	| diagramElement |
	model := Mock new.
	model stub name willReturn: 'bravo'.
	diagramElement := Mock new.
	controller model: model.
	controller diagramElement: diagramElement.
	self stubRefresh.
	controller descriptionName accessor write: 'charlie' to: controller.
	model should receive name: 'charlie'.
	self assert: (controller descriptionName accessor read: controller) equals: 'bravo'.
	diagramElement should receive modelChanged 
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testIsSupported [

	self class = OPAbstractElementControllerTest ifTrue: [ ^ self ].
	super testIsSupported
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testModelClass [
	self assert: controller modelClass equals: self modelClass
]

{ #category : 'tests' }
OPAbstractElementControllerTest >> testModelIsSubscribedTo [
	controller := OPController new.
	model := self modelClass new.
	controller model: model.
	self assert: model announcer subscriptions subscriptions anyOne subscriber equals: controller
]
