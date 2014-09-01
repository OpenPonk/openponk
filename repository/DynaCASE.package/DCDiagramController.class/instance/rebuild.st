userinterface
rebuild
	| els |
	controllers := nil.
	self view cleanAll.
	model elements do: [ :each | self addModelElement: each ].
	self updateView