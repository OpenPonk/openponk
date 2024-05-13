Extension { #name : 'RSEvent' }

{ #category : '*OpenPonk-Roassal' }
RSEvent >> element [

	self
		deprecated: 'Use shape instead.'
		transformWith: '`@receiver element' -> '`@receiver shape'.
	^ self shape
]

{ #category : '*OpenPonk-Roassal' }
RSEvent >> view [

	self
		deprecated: 'Use canvas instead.'
		transformWith: '`@receiver view' -> '`@receiver canvas'.
	^ self canvas
]
