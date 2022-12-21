Extension { #name : #RSAbstractLine }

{ #category : #'*OpenPonk-Roassal3' }
RSAbstractLine >> labels [

	^ self propertyAt: #OPLabels ifAbsentPut: [ Dictionary new ]
]
