"
Unit tests for OPBoundaryController. 
Verifies the interaction logic, target establishment, and rendering updates of boundary boxes in diagrams.
"
Class {
	#name : 'OPBoundaryControllerTest',
	#superclass : 'OPDiagramOnlyControllerTest',
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'constants' }
OPBoundaryControllerTest class >> diagramElementClass [

	^ OPBoundary
]

{ #category : 'constants' }
OPBoundaryControllerTest >> controllerClass [

	^ OPBoundaryController
]

{ #category : 'constants' }
OPBoundaryControllerTest >> diagramControllerClass [

	^ OPTestDiagramController
]

{ #category : 'constants' }
OPBoundaryControllerTest >> diagramModelClass [

	^ OPTestContainerModel
]
