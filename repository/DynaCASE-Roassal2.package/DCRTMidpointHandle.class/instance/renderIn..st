as yet unclassified
renderIn: aView
	element := self shape element.
	element @ RTDraggable.
	self constraintFor: element.
	element when: TRMouseDragStart do: [ :event | self promote ].
	aView add: element