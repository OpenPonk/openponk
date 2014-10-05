removing
remove: anElement
	elements remove: anElement.
	anElement removedFrom: self.
	self announcer announce: (DCElementRemoved element: anElement)