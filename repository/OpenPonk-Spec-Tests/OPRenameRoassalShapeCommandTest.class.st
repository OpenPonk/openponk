"
Tests canvas-level interactive shape renaming and transactional command dispatching.
"
Class {
	#name : 'OPRenameRoassalShapeCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'command',
		'diagramController',
		'formSpy',
		'elementController'
	],
	#category : 'OpenPonk-Spec-Tests-Commands-RoassalShape',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'running' }
OPRenameRoassalShapeCommandTest >> setUp [
	super setUp.
	command := OPRenameRoassalShapeCommand new.
	formSpy := OPPropertiesFormFocusSpy new.
	formSpy addTextInput: 'Name'.
	diagramController := Mock new.
	diagramController stub form willReturn: formSpy.
	diagramController stub selectController: Any.
	elementController := Mock new.
	command instVarNamed: #diagramController put: diagramController
]

{ #category : 'running' }
OPRenameRoassalShapeCommandTest >> tearDown [
	command := nil.
	diagramController := nil.
	formSpy := nil.
	elementController := nil.
	super tearDown
]

{ #category : 'tests' }
OPRenameRoassalShapeCommandTest >> testCanBeExecutedOnlyWithSingleSelection [
	command instVarNamed: #controllers put: {  }.
	self
		deny: command canBeExecuted
		description: 'Rename shape command must not be executable when selection is empty'.

	command instVarNamed: #controllers put: { elementController }.
	self
		assert: command canBeExecuted
		description: 'Rename shape command should be executable when exactly one controller is selected'.

	command instVarNamed: #controllers put: { elementController . Mock new }.
	self
		deny: command canBeExecuted
		description: 'Rename shape command must not be executable when multiple controllers are selected'
]

{ #category : 'tests' }
OPRenameRoassalShapeCommandTest >> testExecuteSelectsControllerAndFocusesFirstInput [
	command instVarNamed: #controllers put: { elementController }.
	command execute.

	diagramController should receive selectController: elementController.
	self
		assert: formSpy focusTaken
		description: 'Executing rename shape command should focus the first input in properties form'
]

{ #category : 'tests' }
OPRenameRoassalShapeCommandTest >> testShortcutIsF2 [
	| activation |
	activation := OPRenameRoassalShapeCommand canvasShortcutActivation.
	self assert: activation keyCombination equals: KeyboardKey F2 asKeyCombination
]
