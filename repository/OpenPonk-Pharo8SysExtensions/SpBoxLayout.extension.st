Extension { #name : #SpBoxLayout }

{ #category : #'*OpenPonk-Pharo8SysExtensions' }
SpBoxLayout class >> newLeftToRight [

	^ super new beHorizontal
]

{ #category : #'*OpenPonk-Pharo8SysExtensions' }
SpBoxLayout class >> newTopToBottom [

	^ super new beVertical
]
