rendering
renderIn: aView
	super renderIn: aView.
	element @ RTDraggable.
	element addCallback: (TRTranslationCallback block: [ :aShape :step | self movedBy: step ]).
	element when: TRMouseDragEnd do: [ self removeIfNecessary ]