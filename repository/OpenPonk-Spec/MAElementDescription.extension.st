Extension { #name : #MAElementDescription }

{ #category : #'*OpenPonk-Spec' }
MAElementDescription >> beNonEmpty [
	self addCondition: (MACondition selector: #isNotEmpty) labelled: 'The value is empty.'
]
