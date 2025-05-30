"
I am a mock class for testing ""diagram"" model controllers.
"
Class {
	#name : 'OPTestDiagramController',
	#superclass : 'OPDiagramController',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'testing' }
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

{ #category : 'accessing' }
OPTestDiagramController >> elementsToShowInside [

	^ self model entities
]

{ #category : 'destruction' }
OPTestDiagramController >> initializePalette: aPalette [
	(aPalette newCreationEntry: [ OPTestEntityController new ]) label: 'Entity'
]
