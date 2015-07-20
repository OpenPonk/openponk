public - executing
stick
	| block |
	self move.
	block := [ :shape :step | self move ].
	parentShape addCallback: (TRTranslationCallback block: block).
	parentShape addCallback: (TRExtentCallback block: block)