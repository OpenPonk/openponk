accessing
renderIn: aView
	element := self shape elementOn: edge.
	aView add: element.
	element translateTo: pointLink value.
	element @ RTDraggableSnapToGrid center.
	"element @ DCRTRoundedDraggable."
	element addConnectedEdge: edge.
	element
		@
			(RTMenuActivable new
				item: 'Remove' action: [ :e | self removePoint ];
				item: 'Straighten' action: [ :e | self straightenConnection ]).
	element trachelShape
		addCallback:
			(TRTranslationCallback
				block: [ :shape :step | 
					pointLink value: pointLink value + step.
					edge announcer announce: OPRTHandleMoved new ]).
	element when: TRMouseDragEnd do: [ self onDragEnd ]