figures
hideAllElements
	[ self controllers isNotEmpty ] whileTrue: [ self controllers anyOne removeController ].
	self cleanView.
	self view signalUpdate