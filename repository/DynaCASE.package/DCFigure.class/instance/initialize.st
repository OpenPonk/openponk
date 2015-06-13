initialization
initialize
	super initialize.
	figures := RTGroup new.
	removedFigures := OrderedCollection new.
	self initializeFigures.
	self registerInteractions