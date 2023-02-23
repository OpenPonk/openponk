"
I am a mock controller for model entities representing relationships.
"
Class {
	#name : #OPTestRelationController,
	#superclass : #OPDirectionalRelationshipController,
	#instVars : [
		'sourceController'
	],
	#category : #'OpenPonk-Core-Controllers - Tests'
}

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
	self diagramController willRender: self.
	figure := RTBox new elementOn: self model.
	aView add: figure.
	^ self diagramController rendered: self
]

{ #category : #accessing }
OPTestRelationController >> sourceController [
	^ sourceController
]
