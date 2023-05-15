Extension { #name : #Rectangle }

{ #category : #'*OpenPonk-Roassal3' }
Rectangle >> floatCenterX [

	^ origin x + corner x / 2.0
]

{ #category : #'*OpenPonk-Roassal3' }
Rectangle >> floatCenterY [

	^ origin y + corner y / 2.0
]

{ #category : #'*OpenPonk-Roassal3' }
Rectangle >> horizontalAlignmentLinesTo: otherRectangle margin: margin [

	^ self
		  selectAlignmentLinesFrom:
		  (self possibleHorizontalAlignmentLinesTo: otherRectangle)
		  in: margin
]

{ #category : #'*OpenPonk-Roassal3' }
Rectangle >> possibleHorizontalAlignmentLinesTo: otherRectangle [

	^ Array
		  with: (OPRectangleDragAlignmentHorizontalLine
				   draggedFirst: self left @ self floatCenterY
				   draggedSecond: self right @ self floatCenterY
				   comparedFirst:
				   otherRectangle left @ otherRectangle floatCenterY
				   comparedSecond:
				   otherRectangle right @ otherRectangle floatCenterY)
		  with: (OPRectangleDragAlignmentHorizontalLine
				   draggedFirst: self topLeft
				   draggedSecond: self topRight
				   comparedFirst: otherRectangle topLeft
				   comparedSecond: otherRectangle topRight)
		  with: (OPRectangleDragAlignmentHorizontalLine
				   draggedFirst: self bottomLeft
				   draggedSecond: self bottomRight
				   comparedFirst: otherRectangle bottomLeft
				   comparedSecond: otherRectangle bottomRight)
]

{ #category : #'*OpenPonk-Roassal3' }
Rectangle >> possibleVerticalAlignmentLinesTo: otherRectangle [

	^ Array
		  with: (OPRectangleDragAlignmentVerticalLine
				   draggedFirst: self floatCenterX @ self top
				   draggedSecond: self floatCenterX @ self bottom
				   comparedFirst: otherRectangle floatCenterX @ otherRectangle top
				   comparedSecond:
				   otherRectangle floatCenterX @ otherRectangle bottom)
		  with: (OPRectangleDragAlignmentVerticalLine
				   draggedFirst: self topLeft
				   draggedSecond: self bottomLeft
				   comparedFirst: otherRectangle topLeft
				   comparedSecond: otherRectangle bottomLeft)
		  with: (OPRectangleDragAlignmentVerticalLine
				   draggedFirst: self topRight
				   draggedSecond: self bottomRight
				   comparedFirst: otherRectangle topRight
				   comparedSecond: otherRectangle bottomRight)
]

{ #category : #'*OpenPonk-Roassal3' }
Rectangle >> selectAlignmentLinesFrom: alignmentLines in: margin [

	| best |
	best := OrderedCollection new.
	alignmentLines
		select: [ :each | each adaptationDistance < margin ]
		thenDo: [ :each |
			(best isEmpty or: [
				 each adaptationDistance
					 closeTo: best first adaptationDistance
					 absolutePrecision: 0.001 ])
				ifTrue: [ best add: each ]
				ifFalse: [
					each adaptationDistance < best first adaptationDistance ifTrue: [
						best := OrderedCollection with: each ] ] ].
	^ best
]

{ #category : #'*OpenPonk-Roassal3' }
Rectangle >> verticalAlignmentLinesTo: otherRectangle margin: margin [

	^ self
		  selectAlignmentLinesFrom:
		  (self possibleVerticalAlignmentLinesTo: otherRectangle)
		  in: margin
]
