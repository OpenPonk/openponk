Extension { #name : #RSEvent }

{ #category : #'*OpenPonk-Roassal3' }
RSEvent >> element [

	self
		deprecated: 'Use shape instead.'
		transformWith: '`@receiver element' -> '`@receiver shape'.
	^ self shape
]

{ #category : #'*OpenPonk-Roassal3' }
RSEvent >> view [

	self
		deprecated: 'Use canvas instead.'
		transformWith: '`@receiver view' -> '`@receiver canvas'.
	^ self canvas
]
