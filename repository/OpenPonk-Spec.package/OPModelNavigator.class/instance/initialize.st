initialization
initialize
	super initialize.
	childrenMap := Dictionary new.
	adapters := OrderedCollection new.
	self registerAdapters