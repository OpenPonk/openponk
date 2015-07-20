public - resizing
keepExtentOf: conformingShape like: originShape plus: aPoint
	| b |
	self changeExtentOf: conformingShape like: originShape plus: aPoint.
	b := [ :shape :step | self changeExtentOf: conformingShape like: originShape plus: aPoint ].
	originShape
		addCallback: (TRExtentCallback block: b);
		addCallback: (TRTranslationCallback block: b)