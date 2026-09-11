"
Helper class for form tests
"
Class {
	#name : 'OPDynamicFormFocusSpy',
	#superclass : 'OPDynamicForm',
	#instVars : [
		'focusTaken'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPDynamicFormFocusSpy >> focusTaken [
	^ focusTaken
]

{ #category : 'initialization' }
OPDynamicFormFocusSpy >> initialize [
	super initialize.
	focusTaken := false
]

{ #category : 'api - focus' }
OPDynamicFormFocusSpy >> takeKeyboardFocus [
	focusTaken := true.
	^ super takeKeyboardFocus
]
