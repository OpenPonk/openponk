"
I manage two-way data binding specifically for Spec2 text and text-input presenters, preventing infinite update loops during continuous typing.
"
Class {
	#name : 'OPFormTextBinding',
	#superclass : 'OPFormFieldBinding',
	#category : 'OpenPonk-Spec-Form',
	#package : 'OpenPonk-Spec',
	#tag : 'Form'
}

{ #category : 'updating' }
OPFormTextBinding >> applyModelValueToPresenter: aValue [
	| textValue |
	textValue := (aValue ifNil: [ '' ]) asString.
	presenter text = textValue ifFalse: [ presenter text: textValue ]
]

{ #category : 'connecting' }
OPFormTextBinding >> connectPresenter [
	presenter whenTextChangedDo: [ :newText |
		self presenterValueChanged: newText asString ]
]
