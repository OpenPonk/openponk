accessing
text: aString
	self caption text: aString.
	self announcer announce: (DCVisualNodeChanged node: self)