"
Tests dynamic property form generation, layout containment, and focus handling in workbench forms.
"
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
OPPropertiesFormTest >> testEditableDropListAdapterAddToListConvertsTextToString [
	| presenter adapter |
	presenter := OPEditableDropListPresenter new.
	adapter := OPMorphicEditableDropListAdapter new.
	adapter adapt: presenter.
	adapter addToList: '2..4' asText.

	self assert: presenter selectedItem isString description: 'Presenter selectedItem must be a String'.
	self assert: presenter selectedItem equals: '2..4'
]

{ #category : 'tests' }
OPPropertiesFormTest >> testExtensibleSingleOptionAppliesCustomValueToPresenter [
	| dummyTarget visitor description control |
	dummyTarget := OPPropertiesFormDummyViewModel new.
	dummyTarget value: '0..5'.
	form viewModel: dummyTarget.
	visitor := OPPropertiesFormMagritteVisitor new.
	visitor form: form.
	visitor viewModel: dummyTarget.
	description := MASingleOptionDescription new
		beExtensible;
		options: #( '0..1' '1..1' '0..*' '1..*' );
		reference: MAStringDescription new;
		accessor: #value;
		label: 'Multiplicity';
		yourself.
	visitor visit: description.
	control := form components detect: [ :each | (each respondsTo: #isEditable) and: [ each isEditable ] ] ifNone: [ nil ].
	self assert: control notNil description: 'Control should be created'.
	self assert: control selectedItem equals: '0..5'
]

{ #category : 'tests' }
OPPropertiesFormTest >> testExtensibleSingleOptionWritingCustomValueUpdatesModelAndUndoReverts [
	| dummyTarget undoManager visitor description control binding |
	undoManager := OPUndoManager new.
	form undoManager: undoManager.
	dummyTarget := OPPropertiesFormDummyViewModel new.
	dummyTarget value: '0..1'.
	form viewModel: dummyTarget.
	visitor := OPPropertiesFormMagritteVisitor new.
	visitor form: form.
	visitor viewModel: dummyTarget.
	description := MASingleOptionDescription new
		beExtensible;
		options: #( '0..1' '1..1' '0..*' '1..*' );
		reference: MAStringDescription new;
		accessor: #value;
		label: 'Multiplicity';
		yourself.
	visitor visit: description.
	control := form components detect: [ :each | (each respondsTo: #isEditable) and: [ each isEditable ] ] ifNone: [ nil ].
	binding := form bindings detect: [ :each | each presenter = control ].

	binding presenterValueChanged: '0..7'.
	self assert: dummyTarget value equals: '0..7'.

	undoManager undo.
	self assert: dummyTarget value equals: '0..1'.
	self assert: control selectedItem equals: '0..1'
]

{ #category : 'tests' }
OPPropertiesFormTest >> testExtensibleSingleOptionWritingThroughMorphicAdapterUpdatesModel [
	| dummyTarget visitor description control adapter |
	dummyTarget := OPPropertiesFormDummyViewModel new.
	dummyTarget value: '0..1'.
	form viewModel: dummyTarget.
	visitor := OPPropertiesFormMagritteVisitor new.
	visitor form: form.
	visitor viewModel: dummyTarget.
	description := MASingleOptionDescription new
		beExtensible;
		options: #( '0..1' '1..1' '0..*' '1..*' );
		reference: MAStringDescription new;
		accessor: #value;
		label: 'Multiplicity';
		yourself.
	visitor visit: description.
	control := form components detect: [ :each | (each respondsTo: #isEditable) and: [ each isEditable ] ].
	adapter := OPMorphicEditableDropListAdapter new.
	adapter adapt: control.

	adapter addToList: '2..4' asText.
	self assert: dummyTarget value equals: '2..4'.
	self assert: dummyTarget value isString
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

{ #category : 'tests' }
OPPropertiesFormTest >> testVisitingExtensibleSingleOptionDescriptionCreatesEditableControl [
	| dummyTarget visitor description control |
	dummyTarget := OPPropertiesFormDummyViewModel new.
	dummyTarget value: '0..1'.
	form viewModel: dummyTarget.
	visitor := OPPropertiesFormMagritteVisitor new.
	visitor form: form.
	visitor viewModel: dummyTarget.
	description := MASingleOptionDescription new
		beExtensible;
		options: #( '0..1' '1..1' '0..*' '1..*' );
		reference: MAStringDescription new;
		accessor: #value;
		label: 'Multiplicity';
		yourself.
	visitor visit: description.
	control := form components detect: [ :each | (each respondsTo: #isEditable) and: [ each isEditable ] ] ifNone: [ nil ].
	self assert: control notNil description: 'Extensible single option must create an editable control'.
	self assert: control isEditable
]
