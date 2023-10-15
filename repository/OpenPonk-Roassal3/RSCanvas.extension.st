Extension { #name : #RSCanvas }

{ #category : #'*OpenPonk-Roassal3' }
RSCanvas >> elements [

	self
		deprecated: 'Use #nodes instead.'
		transformWith: '`@receiver elements' -> '`@receiver nodes'.
	^ self nodes
]

{ #category : #'*OpenPonk-Roassal3' }
RSCanvas >> isSelectable [

	^ false
]

{ #category : #'*OpenPonk-Roassal3' }
RSCanvas >> shapesWithActionForPosition: aPositionInSpace [

	| result |
	result := self shapeCollection shapesAtPoint: aPositionInSpace.

	result := result select: [ :s | s hasEventCallback ].
	self canvas
		propertyAt: #ignoredElementsForEvents
		ifPresent: [ :ignoredOnes | ^ result difference: ignoredOnes ].
	^ result
]
