Extension { #name : #RSShape }

{ #category : #'*OpenPonk-Roassal' }
RSShape >> asEmptyMarker [

	^ self asMarker asEmptyMarker
]

{ #category : #'*OpenPonk-Roassal' }
RSShape >> extentWithoutBorder [

	^ self extent - (border ifNil: [ 0 ] ifNotNil: [ border width ])
]

{ #category : #'*OpenPonk-Roassal' }
RSShape >> isElement [

	self
		deprecated: 'Use isNode instead.'
		transformWith: '`@receiver isElement' -> '`@receiver isNode'.
	^ self isNode
]

{ #category : #'*OpenPonk-Roassal' }
RSShape >> isSelectable [

	^ self hasProperty: OPRSSelectable
]

{ #category : #'*OpenPonk-Roassal' }
RSShape >> isSelected [

	^ self canvas
		  ifNil: [ false ]
		  ifNotNil: [ :currentCanvas | 
		  currentCanvas selectedShapes includes: self ]
]

{ #category : #'*OpenPonk-Roassal' }
RSShape >> shapeWithActionForPosition: position [

	self canvas
		propertyAt: #ignoredElementsForEvents
		ifPresent: [ :ignoredOnes |
		(ignoredOnes includes: self) ifTrue: [ ^ nil ] ].
	^ (self hasEventCallback and: [ self includesPoint: position ])
		  ifTrue: [ self ]
		  ifFalse: [ nil ]
]

{ #category : #'*OpenPonk-Roassal' }
RSShape >> view [

	self
		deprecated: 'Use canvas instead.'
		transformWith: '`@receiver view' -> '`@receiver canvas'.
	^ self canvas
]
