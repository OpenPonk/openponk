"
I am a mock controller for model entities representing relationships.
"
Class {
	#name : #OPTestRelationController,
	#superclass : #OPElementController,
	#instVars : [
		'sourceController'
	],
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #construction }
OPTestRelationController >> createModelIn: aParentModel [
	model := self modelClass new.
	model source: sourceController model.
	model target: aParentModel.
	sourceController diagramController model entities add: model
]

{ #category : #accessing }
OPTestRelationController >> modelClass [
	^ OPTestRelationModel
]

{ #category : #destruction }
OPTestRelationController >> removeModel [
	| ownerModel |
	ownerModel := self diagramController model.
	ownerModel entities remove: self model
]

{ #category : #construction }
OPTestRelationController >> renderFigureIn: aView [
	figure := RTBox new elementOn: self model.
	aView add: figure.
	self diagramController figureAdded: figure
]

{ #category : #accessing }
OPTestRelationController >> sourceController [
	^ sourceController
]

{ #category : #accessing }
OPTestRelationController >> sourceController: aSourceController [
	sourceController := aSourceController
]
