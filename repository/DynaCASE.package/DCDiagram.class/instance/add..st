adding
add: anElement
	elements add: anElement.
	anElement addedTo: self.
	self announcer announce: (DCElementAdded element: anElement)