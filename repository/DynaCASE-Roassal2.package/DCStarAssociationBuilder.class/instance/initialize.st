initialization
initialize
	| block |
	super initialize.
	targets := Set new.
	sources := Set new.
	self
		createCenter;
		defaultEdgeBuilders;
		defaultCenteringBlock.
	block := [ :shape :step | self update ].
	transCallback := TRTranslationCallback block: block.
	extentCallback := TRExtentCallback block: block