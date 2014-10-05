userinterface
rebuild
	controllers := nil.
	self view cleanAll.
	model elements do: [ :each | self addModelElement: each ]