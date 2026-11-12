"
Mock relationship controller used exclusively for testing directional relationship logic and visual edge interactions.
"
Class {
	#name : 'OPTestRelationController',
	#superclass : 'OPDirectionalRelationshipController',
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPTestRelationController class >> diagramElementClass [

	^ OPTestEdge
]

{ #category : 'accessing' }
OPTestRelationController class >> viewModelClass [
	^ OPTestRelationViewModel
]
