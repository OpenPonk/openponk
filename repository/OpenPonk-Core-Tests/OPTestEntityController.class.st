"
Mock element controller. 
Used exclusively for testing interaction, rendering, and source/target resolution of domain entities.
"
Class {
	#name : 'OPTestEntityController',
	#superclass : 'OPElementController',
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
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
