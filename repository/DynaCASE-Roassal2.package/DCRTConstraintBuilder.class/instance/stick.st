public - sticking
stick
	| b |
	self move.
	b := [ :aShape :step | self move ].
	parentShape addCallback: (TRTranslationCallback block: b).
	parentShape addCallback: (TRExtentCallback block: b)