"
I am a mock class for testing ""regular"" model controllers.
"
Class {
	#name : #OPTestEntityController,
	#superclass : #OPElementController,
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #testing }
OPTestEntityController >> canBeSourceFor: aController [
	^ aController modelClass = OPTestRelationModel
]

{ #category : #testing }
OPTestEntityController >> canBeTargetFor: aController [
	^ aController modelClass = OPTestRelationModel
]

{ #category : #construction }
OPTestEntityController >> createModelIn: aParentModel [
	self model: self modelClass new.
	aParentModel entities add: model
]

{ #category : #accessing }
OPTestEntityController >> modelClass [
	^ OPTestEntityModel
]

{ #category : #destruction }
OPTestEntityController >> removeModel [
	| ownerModel |
	ownerModel := self diagramController model.
	ownerModel entities remove: self model
]

{ #category : #construction }
OPTestEntityController >> renderFigureIn: aView [
	figure := RTBox new size: 50; elementOn: self model.
	aView add: figure.
	self diagramController figureAdded: figure
]
