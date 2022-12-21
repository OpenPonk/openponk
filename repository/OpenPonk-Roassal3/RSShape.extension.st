Extension { #name : #RSShape }

{ #category : #'*OpenPonk-Roassal3' }
RSShape >> asEmptyMarker [

	self color: Color white.
	^ OPRSEmptyMarker new shape: self
]

{ #category : #'*OpenPonk-Roassal3' }
RSShape >> isElement [

	self
		deprecated: 'Use isNode instead.'
		transformWith: '`@receiver isElement' -> '`@receiver isNode'.
	^ self isNode
]

{ #category : #'*OpenPonk-Roassal3' }
RSShape >> isSelectable [

	^ self hasProperty: OPRSSelectable
]

{ #category : #'*OpenPonk-Roassal3' }
RSShape >> isSelected [

	^ self canvas
		  ifNil: [ false ]
		  ifNotNil: [ :currentCanvas | 
		  currentCanvas selectedShapes includes: self ]
]

{ #category : #'*OpenPonk-Roassal3' }
RSShape >> isSelectionDraggable [

	^ self hasProperty: OPRSSelectionDraggable
]

{ #category : #'*OpenPonk-Roassal3' }
RSShape >> shape [

	self
		deprecated: 'This is a shape.'
		transformWith: '`@receiver shape' -> '`@receiver'.
	^ self
]

{ #category : #'*OpenPonk-Roassal3' }
RSShape >> view [

	self
		deprecated: 'Use canvas instead.'
		transformWith: '`@receiver view' -> '`@receiver canvas'.
	^ self canvas
]
