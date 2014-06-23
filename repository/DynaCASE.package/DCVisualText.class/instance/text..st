accessing
text: aString
	text := aString.
	self resetBounds.
	self width: (self font widthOfString: aString).
	self changed