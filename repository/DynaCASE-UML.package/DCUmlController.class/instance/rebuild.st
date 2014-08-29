as yet unclassified
rebuild
	| els |
	controllers := nil.
	self view cleanAll.
	model elements do: [ :each | self addModelElement: each ].
	els := self view elements select: [ :el | el shape isKindOf: RTBox ].
	RTGridLayout on: els.
	self updateView