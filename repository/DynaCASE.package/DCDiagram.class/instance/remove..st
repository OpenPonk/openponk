removing
remove: anElement
	elements remove: anElement.
	self announcer announce: (DCElementRemoved element: anElement)