as yet unclassified
rebuild
	controllers := nil.
	self view cleanAll.
	model elements do: [ :each | self addModelElement: each ].
	self updateView