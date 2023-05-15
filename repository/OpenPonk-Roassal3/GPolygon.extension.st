Extension { #name : #GPolygon }

{ #category : #'*OpenPonk-Roassal3' }
GPolygon >> bottom [

	^ self encompassingRectangle bottom
]

{ #category : #'*OpenPonk-Roassal3' }
GPolygon >> left [

	^ self encompassingRectangle left
]

{ #category : #'*OpenPonk-Roassal3' }
GPolygon >> right [

	^ self encompassingRectangle right
]

{ #category : #'*OpenPonk-Roassal3' }
GPolygon >> top [

	^ self encompassingRectangle top
]
