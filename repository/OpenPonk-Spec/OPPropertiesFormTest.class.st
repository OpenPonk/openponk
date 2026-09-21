Class {
	#name : 'OPPropertiesFormTest',
	#superclass : 'TestCase',
	#instVars : [
		'form'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPPropertiesFormTest >> setUp [
	super setUp.
	form := OPPropertiesForm new
]

{ #category : 'running' }
OPPropertiesFormTest >> tearDown [
	form := nil.
	super tearDown
]

{ #category : 'tests' }
OPPropertiesFormTest >> testBindDroplistPropertyItemsAppliesInitialValueWithoutError [

	| dummyTarget control |
	dummyTarget := OPPropertiesFormDummyViewModel new.
	dummyTarget value: #OptionB.
	form := OPPropertiesForm new.
	form viewModel: dummyTarget.
	control := form bindDroplist: 'Choice' property: #value items: #( #OptionA #OptionB #OptionC ).
	self assert: control selectedItem equals: #OptionB
]

{ #category : 'tests' }
OPPropertiesFormTest >> testBindNumberInputRegistersBinding [
	| target numberInput |
	target := OPPropertiesFormDummyViewModel new.
	target value: 42.
	form viewModel: target.
	numberInput := form bindNumberInput: 'Value' property: #value.
	self assert: (form bindings anySatisfy: [ :each | each selector = #value ]).
	self assert: numberInput number equals: 42
]

{ #category : 'tests' }
OPPropertiesFormTest >> testBindNumberInputUpdatesModelAndUndoReverts [
	| target numberInput undoManager |
	undoManager := OPUndoManager new.
	form undoManager: undoManager.
	target := OPPropertiesFormDummyViewModel new.
	target value: 10.
	form viewModel: target.
	numberInput := form bindNumberInput: 'Value' property: #value.

	numberInput number: 99.
	self assert: target value equals: 99.

	undoManager undo.
	self assert: target value equals: 10.
	self assert: numberInput number equals: 10
]

{ #category : 'tests' }
OPPropertiesFormTest >> testFocusFirstInputSelectsAllText [
	"Verify that focusing the first input also selects its entire text content for immediate overwriting."
	| nameInput |
	nameInput := form addTextInput: 'Name'.
	nameInput text: 'Class'.

	form focusFirstInput.

	self assert: nameInput selectionInterval equals: (1 to: 5)
]

{ #category : 'tests' }
OPPropertiesFormTest >> testFocusFirstInputTakesKeyboardFocus [
	"Form must request keyboard focus when explicitly asked via #focusFirstInput"
	| spyForm |
	spyForm := OPPropertiesFormFocusSpy new.
	spyForm addTextInput: 'Name'.

	spyForm focusFirstInput.

	self assert: spyForm focusTaken
]

{ #category : 'tests' }
OPPropertiesFormTest >> testFocusFirstInputWhenEmptyDoesNotTakeKeyboardFocus [
	"Form must not request keyboard focus if there are no focusable controls"
	| spyForm |
	spyForm := OPPropertiesFormFocusSpy new.

	spyForm focusFirstInput.

	self deny: spyForm focusTaken
]

{ #category : 'tests' }
OPPropertiesFormTest >> testFocusOrderExcludesLabels [
	"Ensure non-interactive labels are never registered in focusOrder"

	form addHeadingLabel: 'Section Title'.
	form addTextInput: 'Name'.
	form addDroplist: 'Type'.

	self deny: (form focusOrder anySatisfy: [ :each | each isKindOf: SpLabelPresenter ]).
	self assert: (form focusOrder allSatisfy: [ :each | (each isKindOf: SpLabelPresenter) not ])
]

{ #category : 'tests' }
OPPropertiesFormTest >> testTargetDoesNotStealKeyboardFocus [
	"Form must not request keyboard focus when switching targets"
	| spyForm dummyTarget |
	spyForm := OPPropertiesFormFocusSpy new.
	dummyTarget := OPPropertiesFormDummyViewModel new.

	spyForm viewModel: dummyTarget.

	self deny: spyForm focusTaken
]
