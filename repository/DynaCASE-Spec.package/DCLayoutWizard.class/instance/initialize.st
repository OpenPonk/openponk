initialize-release
initialize
	super initialize.
	toNumberBlock := [ :val | val ].
	self addPane.
	self atEndDo: [ :values | self applyLayoutWith: values ]