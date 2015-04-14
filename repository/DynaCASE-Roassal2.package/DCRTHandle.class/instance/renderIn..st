accessing
renderIn: aView
	element := self shape element.
	aView add: element.
	element translateTo: positionHolder value.
	element @ RTDraggable.
	element addConnectedEdge: edge.
	element when: TRMouseRightClick do: [ :event |  ].

	element trachelShape
		addCallback: (TRTranslationCallback block: [ :shape :step | positionHolder value: positionHolder value + step ])