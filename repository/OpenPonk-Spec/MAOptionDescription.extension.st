Extension { #name : #MAOptionDescription }

{ #category : #'*OpenPonk-Spec' }
MAOptionDescription >> iconForOption: anObject [
	self
		propertyAt: #icons
		ifPresent: [ :icons | icons at: anObject ifPresent: [ :value | ^ value ] ].
	^ nil
]

{ #category : #'*OpenPonk-Spec' }
MAOptionDescription >> icons: aDictionary [
	self propertyAt: #icons put: aDictionary
]
