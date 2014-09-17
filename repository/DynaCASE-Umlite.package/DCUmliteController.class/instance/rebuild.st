as yet unclassified
rebuild
	| els |
	controllers := nil.
	self view cleanAll.
	model elements do: [ :each | self addModelElement: each ].
	els := (self controllers collect: [ :ctrl | ctrl view ]) select: [ :el | el isKindOf: RTElement ].
	els size > 0
		ifTrue: [ RTGridLayout on: els withGap: 200 withLineItemsCount: 3 ].
	self updateView