"
I manage two-way data binding for Spec2 drop-down list presenters, gracefully handling nil selections.
"
Class {
	#name : 'OPFormDropListBinding',
	#superclass : 'OPFormFieldBinding',
	#category : 'OpenPonk-Spec-Form',
	#package : 'OpenPonk-Spec',
	#tag : 'Form'
}

{ #category : 'updating' }
OPFormDropListBinding >> applyModelValueToPresenter: aValue [
	presenter selectedItem = aValue ifTrue: [ ^ self ].
	aValue
		ifNotNil: [
			((presenter respondsTo: #selectItem:) and: [
				(presenter respondsTo: #items) and: [ presenter items includes: aValue ] ])
					ifTrue: [ presenter selectItem: aValue ] ]
		ifNil: [
			(presenter respondsTo: #resetSelection)
				ifTrue: [ presenter resetSelection ]
				ifFalse: [
					(presenter respondsTo: #selectIndex:) ifTrue: [ presenter selectIndex: 0 ] ] ]
]

{ #category : 'connecting' }
OPFormDropListBinding >> connectPresenter [
	presenter whenSelectedItemChangedDo: [ :newItem |
		self presenterValueChanged: newItem ]
]
