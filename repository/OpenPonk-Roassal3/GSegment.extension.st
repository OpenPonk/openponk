Extension { #name : #GSegment }

{ #category : #'*OpenPonk-Roassal3' }
GSegment >> bottom [

	^ v1 y max: v2 y
]

{ #category : #'*OpenPonk-Roassal3' }
GSegment >> left [

	^ v1 x min: v2 x
]

{ #category : #'*OpenPonk-Roassal3' }
GSegment >> right [

	^ v1 x max: v2 x
]

{ #category : #'*OpenPonk-Roassal3' }
GSegment >> top [

	^ v1 y min: v2 y
]
