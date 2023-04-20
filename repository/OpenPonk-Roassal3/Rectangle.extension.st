Extension { #name : #Rectangle }

{ #category : #'*OpenPonk-Roassal3' }
Rectangle >> bestAlignmentLineTo: otherRectangle margin: margin [

	| best |
	best := OPRectangleDragAlignmentVerticalLine
		        draggedFirst: self topCenter
		        draggedSecond: self bottomCenter
		        comparedFirst: otherRectangle topCenter
		        comparedSecond: otherRectangle bottomCenter.
	{
		(OPRectangleDragAlignmentHorizontalLine
			 draggedFirst: self leftCenter
			 draggedSecond: self rightCenter
			 comparedFirst: otherRectangle leftCenter
			 comparedSecond: otherRectangle rightCenter).
		(OPRectangleDragAlignmentVerticalLine
			 draggedFirst: self topLeft
			 draggedSecond: self bottomLeft
			 comparedFirst: otherRectangle topLeft
			 comparedSecond: otherRectangle bottomLeft).
		(OPRectangleDragAlignmentVerticalLine
			 draggedFirst: self topRight
			 draggedSecond: self bottomRight
			 comparedFirst: otherRectangle topRight
			 comparedSecond: otherRectangle bottomRight).
		(OPRectangleDragAlignmentHorizontalLine
			 draggedFirst: self topLeft
			 draggedSecond: self topRight
			 comparedFirst: otherRectangle topLeft
			 comparedSecond: otherRectangle topRight).
		(OPRectangleDragAlignmentHorizontalLine
			 draggedFirst: self bottomLeft
			 draggedSecond: self bottomRight
			 comparedFirst: otherRectangle bottomLeft
			 comparedSecond: otherRectangle bottomRight) } do: [ :each |
		each adaptationDistance < best adaptationDistance ifTrue: [
			best := each ] ].
	^ best adaptationDistance < margin ifTrue: [ best ]
]
