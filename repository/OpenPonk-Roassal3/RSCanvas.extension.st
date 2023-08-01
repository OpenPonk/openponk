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
RSCanvas >> shapeWithActionForPositionInPixels: position [

	| block |
	block := [ :list :pos | 
	         (self
		          propertyAt: #shapesIgnoringMouseMoveBlock
		          ifPresent: [ :ignoredShapes | 
		          list copyWithoutAll: ignoredShapes value ]
		          ifAbsent: [ list ]) reverseDo: [ :s | 
		         (s shapeWithActionForPosition: pos) ifNotNil: [ :shape | 
			         ^ shape ] ] ].
	block value: fixedShapes value: position.
	block value: shapes value: (self camera fromPixelToSpace: position)
]
