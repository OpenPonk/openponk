removing
remove: anElement
	elements remove: anElement.
	anElement removedFrom: self.
	anElement announcer unsubscribe: self.
	self changed.
	self announce: (DCElementRemoved element: anElement)