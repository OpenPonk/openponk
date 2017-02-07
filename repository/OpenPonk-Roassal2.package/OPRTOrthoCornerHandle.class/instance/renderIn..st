rendering
renderIn: aView
	super renderIn: aView.
	element @ OPRTRoundedDraggable.
	element addCallback: (TRTranslationCallback block: [ :aShape :step | self movedBy: step ])