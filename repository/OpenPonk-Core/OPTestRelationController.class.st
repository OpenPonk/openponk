"
I am a mock controller for model entities representing relationships.
"
Class {
	#name : 'OPTestRelationController',
	#superclass : 'OPDirectionalRelationshipController',
	#instVars : [
		'sourceController'
	],
	#category : 'OpenPonk-Core-Controllers - Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers - Tests'
}

{ #category : 'construction' }
OPTestRelationController >> diagramElementClass [

	^ OPTestEdge
]

{ #category : 'accessing' }
OPTestRelationController >> modelClass [
	^ OPTestRelationModel
]

{ #category : 'destruction' }
OPTestRelationController >> removeModel [
	| ownerModel |
	ownerModel := self diagramController model.
	ownerModel entities remove: self model
]
