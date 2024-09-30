Extension { #name : 'GPolygon' }

{ #category : '*OpenPonk-Roassal' }
GPolygon >> bottom [

	^ self encompassingRectangle bottom
]

{ #category : '*OpenPonk-Roassal' }
GPolygon >> left [

	^ self encompassingRectangle left
]

{ #category : '*OpenPonk-Roassal' }
GPolygon >> right [

	^ self encompassingRectangle right
]

{ #category : '*OpenPonk-Roassal' }
GPolygon >> top [

	^ self encompassingRectangle top
]
