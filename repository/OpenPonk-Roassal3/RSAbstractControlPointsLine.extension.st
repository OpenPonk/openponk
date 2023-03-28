Extension { #name : #RSAbstractControlPointsLine }

{ #category : #'*OpenPonk-Roassal3' }
RSAbstractControlPointsLine >> innerControlPoints: aCollection [

	self controlPoints: { self controlPoints first } , aCollection
		, { self controlPoints last }
]
