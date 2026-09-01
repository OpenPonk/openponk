"
Unit tests for OPNoteController. 
Verifies the lifecycle mapping and shape interactions of visual note controllers.
"
Class {
	#name : 'OPNoteControllerTest',
	#superclass : 'OPDiagramOnlyControllerTest',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'constants' }
OPNoteControllerTest class >> diagramElementClass [

	^ OPNote
]

{ #category : 'constants' }
OPNoteControllerTest >> controllerClass [

	^ OPNoteController
]

{ #category : 'constants' }
OPNoteControllerTest >> diagramControllerClass [

	^ OPTestDiagramController
]

{ #category : 'constants' }
OPNoteControllerTest >> diagramModelClass [

	^ OPTestContainerModel
]
