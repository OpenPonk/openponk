userinterface
rebuild
	| els |
	super rebuild.
	els := (self controllers collect: [ :ctrl | ctrl figure ]) select: [ :el | el isKindOf: RTElement ].
	els size > 0
		ifTrue: [ 
			RTGridLayout new
				gapSize: 80;
				on: els ].
	self updateView