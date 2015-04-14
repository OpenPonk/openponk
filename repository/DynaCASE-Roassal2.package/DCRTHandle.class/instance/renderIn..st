accessing
renderIn: aView
	element := self shape element.
	aView add: element.
	element translateTo: pointLink value.
	element @ RTDraggable.
	element addConnectedEdge: edge.
	element @ (RTMenuActivable new item: 'Remove' action: [ :e | self removePoint ]).
	element trachelShape
		addCallback: (TRTranslationCallback block: [ :shape :step | pointLink value: pointLink value + step ]).
	element when: TRMouseDragEnd do: [ self onDragEnd ]