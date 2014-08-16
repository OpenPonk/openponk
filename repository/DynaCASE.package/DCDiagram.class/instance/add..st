adding
add: anElement
	elements add: anElement.
	self announcer announce: (DCElementAdded element: anElement)