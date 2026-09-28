"
A dynamic form field binding that synchronizes a numerical text input presenter with an integer or float domain model property.
"
Class {
	#name : 'OPFormNumberBinding',
	#superclass : 'OPFormFieldBinding',
	#category : 'OpenPonk-Spec-Form-Bindings',
	#package : 'OpenPonk-Spec',
	#tag : 'Form-Bindings'
}

{ #category : 'updating' }
OPFormNumberBinding >> applyModelValueToPresenter: aValue [
	| numberValue |
	numberValue := aValue ifNil: [ 0 ].
	presenter number = numberValue ifFalse: [ presenter number: numberValue ]
]

{ #category : 'connecting' }
OPFormNumberBinding >> connectPresenter [
	presenter whenNumberChangedDo: [ :newNumber |
		self presenterValueChanged: newNumber ]
]
