Extension { #name : #RSCanvas }

{ #category : #'*OpenPonk-Roassal' }
RSCanvas >> elements [

	self
		deprecated: 'Use #nodes instead.'
		transformWith: '`@receiver elements' -> '`@receiver nodes'.
	^ self nodes
]

{ #category : #'*OpenPonk-Roassal' }
RSCanvas >> isSelectable [

	^ false
]

{ #category : #'*OpenPonk-Roassal' }
RSCanvas >> shapesWithActionForPosition: aPositionInSpace [

	| result |
	result := self shapeCollection shapesAtPoint: aPositionInSpace.

	result := result select: [ :s | s hasEventCallback ].
	self canvas
		propertyAt: #ignoredElementsForEvents
		ifPresent: [ :ignoredOnes | ^ result difference: ignoredOnes ].
	^ result
]
