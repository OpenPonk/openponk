Extension { #name : #RSObjectWithProperty }

{ #category : #'*OpenPonk-Roassal3' }
RSObjectWithProperty >> isOrComposesOf: aShape [

	^ self = aShape
]

{ #category : #'*OpenPonk-Roassal3' }
RSObjectWithProperty >> isSelectionDraggable [

	^ self hasProperty: OPRSSelectionDraggable
]
