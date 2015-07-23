hooks
attachHandle: aHandle toCorner: aCorner
	aHandle addCallback: (TRTranslationCallback block: [ :shape :step | self callbackFor: aHandle corner: aCorner ]).
	self addCursorEventsOn: aHandle corner: aCorner.
	(RTConstraint child: aHandle parent: element)
		perform: aCorner;
		border;
		stick