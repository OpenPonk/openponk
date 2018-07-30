figures
hideAllElements
	[ controllers isNotEmpty ] whileTrue: [ controllers anyOne removeController ].
	self cleanView.
	self view signalUpdate