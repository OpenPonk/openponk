"
I am a mock class for testing ""regular"" model controllers.
"
Class {
	#name : 'OPTestEntityController',
	#superclass : 'OPElementController',
	#category : 'OpenPonk-Core-Controllers - Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers - Tests'
}

{ #category : 'testing' }
OPTestEntityController >> canBeSourceFor: aController [
	^ aController modelClass = OPTestRelationModel
]

{ #category : 'testing' }
OPTestEntityController >> canBeTargetFor: aController [
	^ aController modelClass = OPTestRelationModel
]

{ #category : 'construction' }
OPTestEntityController >> diagramElementClass [

	^ OPTestDiagramElement
]

{ #category : 'connecting' }
OPTestEntityController >> modelAsParent [
	^ self diagramController model
]

{ #category : 'accessing' }
OPTestEntityController >> modelClass [
	^ OPTestEntityModel
]

{ #category : 'destruction' }
OPTestEntityController >> removeModel [
	| ownerModel |
	ownerModel := self diagramController model.
	ownerModel entities remove: self model
]
