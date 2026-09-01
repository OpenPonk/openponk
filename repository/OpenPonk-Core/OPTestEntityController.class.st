"
Mock element controller. 
Used exclusively for testing interaction, rendering, and source/target resolution of domain entities.
"
Class {
	#name : 'OPTestEntityController',
	#superclass : 'OPElementController',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'construction' }
OPTestEntityController class >> diagramElementClass [

	^ OPTestDiagramElement
]

{ #category : 'accessing' }
OPTestEntityController class >> viewModelClass [
	^ OPTestEntityViewModel
]

{ #category : 'connecting' }
OPTestEntityController >> canBeSourceFor: aController [
	^ aController modelClass = OPTestRelationModel
]

{ #category : 'connecting' }
OPTestEntityController >> canBeTargetFor: aController [
	^ aController modelClass = OPTestRelationModel
]
