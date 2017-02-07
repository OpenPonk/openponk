as yet unclassified
renderIn: aView
	element := self shape elementOn: edge trachelShape.
	element @ RTDraggable.
	self constraintFor: element.
	element when: TRMouseDragStart do: [ :event | self promote ].
	aView add: element