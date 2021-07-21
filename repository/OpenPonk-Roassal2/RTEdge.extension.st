Extension { #name : #RTEdge }

{ #category : #'*OpenPonk-Roassal2' }
RTEdge >> labels [
	^ self attributeAt: #OPRTLabels ifAbsentPut: [ Dictionary new ]
]
