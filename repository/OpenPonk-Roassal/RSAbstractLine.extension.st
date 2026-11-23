Extension { #name : 'RSAbstractLine' }

{ #category : '*OpenPonk-Roassal' }
RSAbstractLine >> innerControlPoints [

	^ self controlPoints copyFrom: 2 to: self controlPoints size - 1
]
