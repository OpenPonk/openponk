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
	^ Model
]

{ #category : #accessing }
OPControllerTest >> modelClass [
	^ Model
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
	model := Mock new.
	model stub name willReturn: 'bravo'.
	controller model: model.
	self stubRefresh.
	controller descriptionName accessor write: 'charlie' to: controller.
	model should receive name: 'charlie'.
	self assert: (controller descriptionName accessor read: controller) equals: 'bravo'.
	controller should receive refreshFigure
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
	model := Model new.
	controller model: model.
	self assert: model announcer subscriptions subscriptions anyOne subscriber equals: controller
]
