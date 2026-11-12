Extension { #name : 'OPNoteControllerTest' }

{ #category : '*OpenPonk-Spec-Tests' }
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

	self
		assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #text ])
		description: 'Properties form for OPNoteController should register a binding for #text'.
	self assert: form bindings first readModelValue equals: 'Initial Note Text'.

	form bindings first writeModelValue: 'Updated Note Text'.
	self assert: note text equals: 'Updated Note Text'
]
