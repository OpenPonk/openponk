Extension { #name : #GRectangle }

{ #category : #'*OpenPonk-Roassal3' }
GRectangle >> bottom [

	^ (self vertices at: 3) y
]

{ #category : #'*OpenPonk-Roassal3' }
GRectangle >> left [

	^ (self vertices at: 1) x
]

{ #category : #'*OpenPonk-Roassal3' }
GRectangle >> right [

	^ (self vertices at: 3) x
]

{ #category : #'*OpenPonk-Roassal3' }
GRectangle >> top [

	^ (self vertices at: 1) y
]
