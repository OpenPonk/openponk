Extension { #name : #RSAthensMorph }

{ #category : #'*OpenPonk-Roassal' }
RSAthensMorph >> resetShapeBeingDragged [

	eventBeginingDragging ifNil: [ ^ self ].
	self eventMouseDragStart: eventBeginingDragging
]
