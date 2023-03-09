Class {
	#name : #OPElementControllerTest,
	#superclass : #OPBaseControllerTest,
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #accessing }
OPElementControllerTest >> controllerClass [
	^ OPController
]

{ #category : #accessing }
OPElementControllerTest >> diagramControllerClass [
	^ OPDiagramController
]

{ #category : #accessing }
OPElementControllerTest >> diagramModelClass [

	^ OPTestModel
]

{ #category : #accessing }
OPElementControllerTest >> modelClass [
	^ OPTestModel
]

{ #category : #tests }
OPElementControllerTest >> testCannotConnectByDefault [
	controller model: model.
	self deny: (controller canBeSourceFor: nil).
	self deny: (controller canBeTargetFor: nil)
]

{ #category : #tests }
OPElementControllerTest >> testClassSideModelClass [

	self class = OPElementControllerTest ifTrue: [ 
		^ self
			  should: [ self controllerClass modelClass ]
			  raise: SubclassResponsibility ].
	self assert: self controllerClass modelClass equals: self modelClass
]

{ #category : #'tests - creation' }
OPElementControllerTest >> testCreateDiagramElement [

	self diagramControllerClass = self controllerClass ifTrue: [ 
		self skip ].
	self class = OPElementControllerTest ifTrue: [ self skip ].

	controller model: model.
	controller diagramController: diagramController.
	controller createDiagramElement.
	self
		assert: controller diagramElement class
		equals: self diagramElementClass
]

{ #category : #tests }
OPElementControllerTest >> testDescriptionName [
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

{ #category : #tests }
OPElementControllerTest >> testIsSupported [

	self class = OPElementControllerTest ifTrue: [ ^ self ].
	super testIsSupported
]

{ #category : #tests }
OPElementControllerTest >> testModelClass [
	self should: [ controller modelClass ] raise: SubclassResponsibility
]

{ #category : #tests }
OPElementControllerTest >> testModelIsSubscribedTo [
	controller := OPController new.
	model := self modelClass new.
	controller model: model.
	self assert: model announcer subscriptions subscriptions anyOne subscriber equals: controller
]
