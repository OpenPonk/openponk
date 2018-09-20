Extension { #name : #TRCompositeShape }

{ #category : #'*OpenPonk-Roassal2' }
TRCompositeShape >> addShape: aShape beforeIndex: anIndex [
	^ shapeAndOffsets add: (Array with: aShape with: 0 @ 0) beforeIndex: anIndex
]

{ #category : #'*OpenPonk-Roassal2' }
TRCompositeShape >> addShapeFirst: aShape [
	^ shapeAndOffsets addFirst: (Array with: aShape with: 0 @ 0)
]

{ #category : #'*OpenPonk-Roassal2' }
TRCompositeShape >> removeAt: anIndex [
	^ (shapeAndOffsets removeAt: anIndex) first
]

{ #category : #'*OpenPonk-Roassal2' }
TRCompositeShape >> removeFirst [
	^ shapeAndOffsets removeFirst first
]

{ #category : #'*OpenPonk-Roassal2' }
TRCompositeShape >> removeLast [
	^ shapeAndOffsets removeLast first
]
