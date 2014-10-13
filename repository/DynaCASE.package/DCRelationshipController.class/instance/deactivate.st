interaction
deactivate
	(self view attributes includesKey: #DCInactiveColor)
		ifTrue: [ 
			self view shape color: (self view attributes at: #DCInactiveColor).
			self view attributes removeKey: #DCInactiveColor ].
	self view update