accessing
text: aString
	self name text: aString.
	self announcer announce: (DCVisualNodeChanged node: self)