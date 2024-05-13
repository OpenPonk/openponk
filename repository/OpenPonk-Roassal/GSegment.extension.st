Extension { #name : 'GSegment' }

{ #category : '*OpenPonk-Roassal' }
GSegment >> bottom [

	^ v1 y max: v2 y
]

{ #category : '*OpenPonk-Roassal' }
GSegment >> left [

	^ v1 x min: v2 x
]

{ #category : '*OpenPonk-Roassal' }
GSegment >> right [

	^ v1 x max: v2 x
]

{ #category : '*OpenPonk-Roassal' }
GSegment >> top [

	^ v1 y min: v2 y
]
