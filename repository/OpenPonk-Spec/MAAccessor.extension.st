Extension { #name : #MAAccessor }

{ #category : #'*OpenPonk-Spec' }
MAAccessor >> opUpdateOn: aController [
	self
		propertyAt: #opUpdateBlock
		ifPresent: [ :block | block value: (self read: aController) ]
]

{ #category : #'*OpenPonk-Spec' }
MAAccessor >> opWhenUpdated: aOneArgBlock [
	self propertyAt: #opUpdateBlock put: aOneArgBlock
]
