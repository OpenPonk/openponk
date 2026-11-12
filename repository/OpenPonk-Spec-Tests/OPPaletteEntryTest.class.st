"
Tests tool palette entry creation, icon bindings, and active tool switching in the diagram editor.
"
Class {
	#name : 'OPPaletteEntryTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Palettes',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Palettes'
}

{ #category : 'tests' }
OPPaletteEntryTest >> testWhenCreatedSetupFocusesForm [
	"Verify that creation tool completes and focuses the dynamic form without modal dialogs."
	| paletteEntry creationTool dummyController dummyDiagramController formSpy |
	paletteEntry := OPPaletteEntry new.
	creationTool := OPNodeCreationTool new.
	paletteEntry tool: creationTool.

	formSpy := OPPropertiesFormFocusSpy new.
	formSpy addTextInput: 'Name'.

	dummyDiagramController := Mock new.
	dummyDiagramController stub form willReturn: formSpy.

	dummyController := Mock new.
	dummyController stub diagramController willReturn: dummyDiagramController.

	creationTool instVarNamed: #controller put: dummyController.
	creationTool doOnCompleteActions.

	self
		assert: formSpy focusTaken
		description: 'Completing creation tool should focus first input on properties form'
]

{ #category : 'tests' }
OPPaletteEntryTest >> testWhenCreatedSetupWithoutDiagramController [
	"Verify that creation tool safely executes completion for headless controllers without a diagram controller."
	| paletteEntry creationTool dummyController callbackExecuted |
	callbackExecuted := false.
	paletteEntry := OPPaletteEntry new.
	creationTool := OPNodeCreationTool new.
	paletteEntry tool: creationTool.
	paletteEntry whenCreated: [ :ctrl | callbackExecuted := true ].

	dummyController := Mock new.
	dummyController stub diagramController willReturn: nil.

	creationTool instVarNamed: #controller put: dummyController.
	creationTool doOnCompleteActions.

	self
		assert: callbackExecuted
		description: 'whenCreated: callback should execute even when diagramController is nil'
]
