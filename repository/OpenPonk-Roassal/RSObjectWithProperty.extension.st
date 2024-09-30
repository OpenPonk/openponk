Extension { #name : 'RSObjectWithProperty' }

{ #category : '*OpenPonk-Roassal' }
RSObjectWithProperty >> isOrComposesOf: aShape [

	^ self = aShape
]

{ #category : '*OpenPonk-Roassal' }
RSObjectWithProperty >> isSelectionDraggable [

	^ self hasProperty: OPRSSelectionDraggable
]
