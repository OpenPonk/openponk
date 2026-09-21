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
