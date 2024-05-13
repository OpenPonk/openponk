Extension { #name : 'RSCanvas' }

{ #category : '*OpenPonk-Roassal' }
RSCanvas >> deepShapes [
	"Return the list of all the shapes contained in the visualization"
	| result |
	result := OrderedCollection new.
	self shapes do: [ :n |
		n addRecursivelyIn: result ].
	^ result
]

{ #category : '*OpenPonk-Roassal' }
RSCanvas >> elements [

	self
		deprecated: 'Use #nodes instead.'
		transformWith: '`@receiver elements' -> '`@receiver nodes'.
	^ self nodes
]

{ #category : '*OpenPonk-Roassal' }
RSCanvas >> isSelectable [

	^ false
]

{ #category : '*OpenPonk-Roassal' }
RSCanvas >> shapesWithActionForPosition: aPositionInSpace [

	| result |
	result := self shapeCollection entriesAtPoint: aPositionInSpace.

	self canvas
		propertyAt: #ignoredElementsForEvents
		ifPresent: [ :ignoredOnes |
			^ result select: [ :s |
				  s hasEventCallback and: [ (ignoredOnes includes: s) not ] ] ].

	^ result select: [ :s | s hasEventCallback ]
]
