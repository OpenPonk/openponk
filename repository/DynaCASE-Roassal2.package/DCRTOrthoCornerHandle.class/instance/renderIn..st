rendering
renderIn: aView
	super renderIn: aView.
	element @ DCRTRoundedDraggable.
	element addCallback: (TRTranslationCallback block: [ :aShape :step | self movedBy: step ])