"
Mock diagram controller. 
Used exclusively for testing diagram lifecycle operations, palette initialization, and sub-controller coordination.
"
Class {
	#name : 'OPTestDiagramController',
	#superclass : 'OPDiagramController',
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPTestDiagramController class >> viewModelClass [

	^ OPTestContainerViewModel
]

{ #category : 'connecting' }
OPTestDiagramController >> canBeTargetFor: aController [

	^ (super canBeTargetFor: aController) or: [
		  aController class = OPTestEntityController ]
]

{ #category : 'accessing' }
OPTestDiagramController >> controllerFactory [
	^ super controllerFactory
		register: OPTestEntityController forModel: OPTestEntityModel;
		register: OPTestRelationController forModel: OPTestRelationModel
]

{ #category : 'ui interaction' }
OPTestDiagramController >> initializePalette: aPalette [
	(aPalette newCreationEntry: [ OPTestEntityController new ]) label: 'Entity'
]
