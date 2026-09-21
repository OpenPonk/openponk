"
I manage two-way data binding for Spec2 checkbox presenters.
"
Class {
	#name : 'OPFormCheckboxBinding',
	#superclass : 'OPFormFieldBinding',
	#category : 'OpenPonk-Spec-Form',
	#package : 'OpenPonk-Spec',
	#tag : 'Form'
}

{ #category : 'updating' }
OPFormCheckboxBinding >> applyModelValueToPresenter: aValue [
	| boolValue |
	boolValue := aValue ifNil: [ false ].
	presenter state = boolValue ifFalse: [ presenter state: boolValue ]
]

{ #category : 'connecting' }
OPFormCheckboxBinding >> connectPresenter [
	presenter whenChangedDo: [ :newState |
		self presenterValueChanged: newState ]
]
