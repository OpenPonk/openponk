accessing
letter: aSymbol
	self submorphsDo: #delete.
	self addMorph: (self morphForLetter: aSymbol)