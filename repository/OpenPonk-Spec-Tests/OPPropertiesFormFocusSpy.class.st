"
Helper class for form tests
"
Class {
	#name : 'OPPropertiesFormFocusSpy',
	#superclass : 'OPPropertiesForm',
	#instVars : [
		'focusTaken'
	],
	#category : 'OpenPonk-Spec-Tests-Form',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Form'
}

{ #category : 'accessing' }
OPPropertiesFormFocusSpy >> focusTaken [
	^ focusTaken
]

{ #category : 'initialization' }
OPPropertiesFormFocusSpy >> initialize [
	super initialize.
	focusTaken := false
]

{ #category : 'api - focus' }
OPPropertiesFormFocusSpy >> takeKeyboardFocus [
	focusTaken := true.
	^ super takeKeyboardFocus
]
