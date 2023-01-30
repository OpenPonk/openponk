Extension { #name : #RSAthensMorph }

{ #category : #'*OpenPonk-Roassal3' }
RSAthensMorph >> resetShapeBeingDragged [

	eventBeginingDragging ifNil: [ ^ self ].
	self eventMouseDragStart: eventBeginingDragging
]
