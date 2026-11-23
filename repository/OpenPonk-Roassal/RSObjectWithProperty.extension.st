Extension { #name : 'RSObjectWithProperty' }

{ #category : '*OpenPonk-Roassal' }
RSObjectWithProperty >> isSelectionDraggable [

	^ self hasProperty: OPRSSelectionDraggable
]
