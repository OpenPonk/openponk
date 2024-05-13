Extension { #name : 'RSEventProcessor' }

{ #category : '*OpenPonk-Roassal' }
RSEventProcessor >> resetShapeBeingDragged [

	eventBeginingDragging ifNil: [ ^ self ].
	self eventMouseDragStart: eventBeginingDragging
]
