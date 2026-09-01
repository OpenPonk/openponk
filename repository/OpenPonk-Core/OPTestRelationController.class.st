"
Mock relationship controller used exclusively for testing directional relationship logic and visual edge interactions.
"
Class {
	#name : 'OPTestRelationController',
	#superclass : 'OPDirectionalRelationshipController',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'construction' }
OPTestRelationController class >> diagramElementClass [

	^ OPTestEdge
]

{ #category : 'accessing' }
OPTestRelationController class >> viewModelClass [
	^ OPTestRelationViewModel
]
