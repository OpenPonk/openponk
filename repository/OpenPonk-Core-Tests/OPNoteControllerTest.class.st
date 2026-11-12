"
Unit tests for OPNoteController. 
Verifies the lifecycle mapping and shape interactions of visual note controllers.
"
Class {
	#name : 'OPNoteControllerTest',
	#superclass : 'OPDiagramOnlyControllerTest',
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
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

{ #category : 'tests' }
OPNoteControllerTest >> testDescriptionName [

	| diagramElement |
	diagramElement := self diagramElementClass new.
	diagramElement stub text willReturn: 'bravo'.

	controller model: diagramElement.

	controller viewModel descriptionName accessor
		write: 'charlie'
		to: controller.
	diagramElement should receive text: 'charlie'.
	self
		assert:
		(controller viewModel descriptionName accessor read: controller)
		equals: 'bravo'.
	diagramElement should receive modelChanged
]
