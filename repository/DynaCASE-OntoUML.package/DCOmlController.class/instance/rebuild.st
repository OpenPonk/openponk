userinterface
rebuild
	| els |
	super rebuild.
	els := (self controllers collect: [ :ctrl | ctrl figure ]) select: [ :el | el isKindOf: RTElement ].
	els size > 0
		ifTrue: [ RTGridLayout on: els withGap: 80 withLineItemsCount: 3 ].
	self updateView.
	self view canvas camera focusOnCenter