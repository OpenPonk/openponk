Extension { #name : 'GRectangle' }

{ #category : '*OpenPonk-Roassal' }
GRectangle >> bottom [

	^ (self vertices at: 3) y
]

{ #category : '*OpenPonk-Roassal' }
GRectangle >> left [

	^ (self vertices at: 1) x
]

{ #category : '*OpenPonk-Roassal' }
GRectangle >> right [

	^ (self vertices at: 3) x
]

{ #category : '*OpenPonk-Roassal' }
GRectangle >> top [

	^ (self vertices at: 1) y
]
