userinterface
rebuild
	| els |
	super rebuild.
	els := (self controllers collect: [ :ctrl | ctrl figure ]) select: [ :el | el isKindOf: RTElement ].
	els
		ifNotEmpty: [ 
			RTGridLayout new
				gapSize: 80;
				on: els ].
	self updateView.
	self view canvas camera focusOnCenter