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

{ #category : #'*OpenPonk-Roassal2' }
TRCompositeShape >> verticalAndLeftWithoutReset [
	"Layout the shapes vertically and aligned on the left hand side"

	RTAlignment new
		elements: (shapeAndOffsets collect: #first);
		left.
	RTVerticalLineLayout new
		gapSize: 0;
		on: (shapeAndOffsets collect: #first).
	shapeAndOffsets
		doWithIndex: [ :tuple :index | tuple at: 2 put: tuple first position ]
]
