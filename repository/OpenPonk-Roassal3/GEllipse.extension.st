Extension { #name : #GEllipse }

{ #category : #'*OpenPonk-Roassal3' }
GEllipse >> bottom [

	^ coVertex y max: center y + center y - coVertex y
]

{ #category : #'*OpenPonk-Roassal3' }
GEllipse >> left [

	^ vertex x min: center x + center x - vertex x
]

{ #category : #'*OpenPonk-Roassal3' }
GEllipse >> right [

	^ vertex x max: center x + center x - vertex x
]

{ #category : #'*OpenPonk-Roassal3' }
GEllipse >> top [

	^ coVertex y min: center y + center y - coVertex y
]
