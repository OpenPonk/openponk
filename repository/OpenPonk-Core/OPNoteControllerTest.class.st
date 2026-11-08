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

{ #category : 'tests' }
OPNoteControllerTest >> testBuildEditorFormDelegatesToViewModelAndRegistersTextBinding [

	| project projectController note form |
	project := OPProject new.
	projectController := OPProjectController forProject: project.
	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	note := OPNote new text: 'Initial Note Text'.
	controller := OPNoteController new.
	controller diagramController: diagramController.
	controller diagramElement: note.

	form := OPPropertiesForm new.
	form viewModel: controller.

	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #text ]).
	self assert: form bindings first readModelValue equals: 'Initial Note Text'.

	form bindings first writeModelValue: 'Updated Note Text'.
	self assert: note text equals: 'Updated Note Text'
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
