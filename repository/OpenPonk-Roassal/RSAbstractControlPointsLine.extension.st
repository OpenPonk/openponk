Extension { #name : 'RSAbstractControlPointsLine' }

{ #category : '*OpenPonk-Roassal' }
RSAbstractControlPointsLine >> innerControlPoints: aCollection [

	self controlPoints: { self controlPoints first } , aCollection
		, { self controlPoints last }
]
