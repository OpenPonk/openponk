Class {
	#name : 'OPPaletteEntryTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPPaletteEntryTest >> testWhenCreatedSetupFocusesForm [
	"Verify that whenCreatedSetup configures the completion block to focus the dynamic form without modal dialogs."
	| paletteEntry creationTool dummyCtrl dummyDiagramCtrl formSpy completionBlock |
	paletteEntry := OPPaletteEntry new.
	creationTool := OPCreationTool new.
	paletteEntry tool: creationTool.

	paletteEntry whenCreatedSetup.

	completionBlock := creationTool instVarNamed: #onComplete.
	self assert: completionBlock isNotNil.

	formSpy := OPPropertiesFormFocusSpy new.
	formSpy addTextInput: 'Name'.

	dummyDiagramCtrl := Mock new.
	dummyDiagramCtrl stub form willReturn: formSpy.

	dummyCtrl := Mock new.
	dummyCtrl stub diagramController willReturn: dummyDiagramCtrl.

	completionBlock value: dummyCtrl.

	self assert: formSpy focusTaken
]

{ #category : 'tests' }
OPPaletteEntryTest >> testWhenCreatedSetupWithoutDiagramController [
	"Verify that whenCreatedSetup safely executes for headless controllers without a diagram controller."
	| paletteEntry creationTool dummyCtrl completionBlock |
	paletteEntry := OPPaletteEntry new.
	creationTool := OPCreationTool new.
	paletteEntry tool: creationTool.

	paletteEntry whenCreatedSetup.

	completionBlock := creationTool instVarNamed: #onComplete.
	dummyCtrl := Mock new.
	dummyCtrl stub diagramController willReturn: nil.

	completionBlock value: dummyCtrl
]
