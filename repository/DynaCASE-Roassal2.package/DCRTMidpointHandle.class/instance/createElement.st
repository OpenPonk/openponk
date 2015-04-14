as yet unclassified
createElement
	| el |
	el := self shape element.
	el @ RTDraggable.
	self constraintFor: el.
	el when: TRMouseDragStart do: [ :event | self promote ].
	^ el