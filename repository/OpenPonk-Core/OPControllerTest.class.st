Class {
	#name : #OPControllerTest,
	#superclass : #OPBaseControllerTest,
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #accessing }
OPControllerTest >> controllerClass [
	^ OPController
]

{ #category : #accessing }
OPControllerTest >> diagramControllerClass [
	^ OPDiagramController
]

{ #category : #accessing }
OPControllerTest >> diagramModelClass [
	^ OPTestModel
]

{ #category : #accessing }
OPControllerTest >> modelClass [
	^ OPTestModel
]

{ #category : #tests }
OPControllerTest >> testCannotConnectByDefault [
	controller model: model.
	self deny: (controller canBeSourceFor: nil).
	self deny: (controller canBeTargetFor: nil)
]

{ #category : #tests }
OPControllerTest >> testClassSideModelClass [
	self should: [ self controllerClass modelClass ] raise: SubclassResponsibility
]

{ #category : #tests }
OPControllerTest >> testDescriptionName [
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
OPControllerTest >> testIsSupported [
	self deny: (diagramController hasSupportForModel: model)
]

{ #category : #tests }
OPControllerTest >> testModelClass [
	self should: [ controller modelClass ] raise: SubclassResponsibility
]

{ #category : #tests }
OPControllerTest >> testModelIsSubscribedTo [
	controller := OPController new.
	model := self modelClass new.
	controller model: model.
	self assert: model announcer subscriptions subscriptions anyOne subscriber equals: controller
]
