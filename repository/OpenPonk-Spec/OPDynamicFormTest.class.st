Class {
	#name : 'OPDynamicFormTest',
	#superclass : 'TestCase',
	#instVars : [
		'form'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPDynamicFormTest >> setUp [
	super setUp.
	form := OPDynamicForm new
]

{ #category : 'running' }
OPDynamicFormTest >> tearDown [
	form := nil.
	super tearDown
]

{ #category : 'tests' }
OPDynamicFormTest >> testFocusOrderExcludesLabels [
	"Ensure non-interactive labels are never registered in focusOrder"

	form addHeadingLabel: 'Section Title'.
	form addTextInput: 'Name'.
	form addDroplist: 'Type'.

	self deny: (form focusOrder anySatisfy: [ :each | each isKindOf: SpLabelPresenter ]).
	self assert: (form focusOrder allSatisfy: [ :each | (each isKindOf: SpLabelPresenter) not ])
]

{ #category : 'tests' }
OPDynamicFormTest >> testTargetDoesNotStealKeyboardFocus [
	"Form must not request keyboard focus when switching targets"
	| spyForm dummyTarget |
	spyForm := OPDynamicFormFocusSpy new.
	dummyTarget := OPDynamicFormDummyTarget new.

	spyForm target: dummyTarget.

	self deny: spyForm focusTaken
]
