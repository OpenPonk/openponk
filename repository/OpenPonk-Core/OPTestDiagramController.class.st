"
I am a mock class for testing ""diagram"" model controllers.
"
Class {
	#name : #OPTestDiagramController,
	#superclass : #OPDiagramController,
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #testing }
OPTestDiagramController >> canBeTargetFor: aController [
	^ aController class = OPTestEntityController
]

{ #category : #accessing }
OPTestDiagramController >> elementsToShowInside [
	^ model entities
]

{ #category : #destruction }
OPTestDiagramController >> initializePalette: aPalette [
	(aPalette newCreationEntry: [ OPTestEntityController new ]) label: 'Entity'
]

{ #category : #accessing }
OPTestDiagramController >> modelToControllerMapping [
	^ OPControllerFactory new
		register: OPTestEntityController forModel: OPTestEntityModel;
		register: OPTestRelationController forModel: OPTestRelationModel
]
