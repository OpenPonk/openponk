userinterface
rebuild
	controllers := nil.
	self view cleanAll.
	model elements do: [ :each | self addModelElement: each ].
	RTHorizontalTreeLayout on: self view elements.
	self updateView