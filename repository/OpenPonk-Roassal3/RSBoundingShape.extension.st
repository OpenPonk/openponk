Extension { #name : #RSBoundingShape }

{ #category : #'*OpenPonk-Roassal3' }
RSBoundingShape >> element [

	self
		deprecated: 'There are no elements in Roassal3.'
		transformWith: '`@receiver element' -> '`@receiver yourself'.
	^ self
]

{ #category : #'*OpenPonk-Roassal3' }
RSBoundingShape >> elementOn: aModel [

	self
		deprecated: 'There are no elements in Roassal3.'
		transformWith: '`@receiver elementOn: `@statements1'
			-> '`@receiver model: `@statements1; yourself'.
	^ self
]
