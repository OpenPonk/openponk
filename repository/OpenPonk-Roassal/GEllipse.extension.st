Extension { #name : #GEllipse }

{ #category : #'*OpenPonk-Roassal' }
GEllipse >> bottom [

	^ coVertex y max: center y + center y - coVertex y
]

{ #category : #'*OpenPonk-Roassal' }
GEllipse >> left [

	^ vertex x min: center x + center x - vertex x
]

{ #category : #'*OpenPonk-Roassal' }
GEllipse >> right [

	^ vertex x max: center x + center x - vertex x
]

{ #category : #'*OpenPonk-Roassal' }
GEllipse >> top [

	^ coVertex y min: center y + center y - coVertex y
]
