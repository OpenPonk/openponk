adding
add: anElement
	elements add: anElement.
	anElement addedTo: self.
	anElement when: DCElementChanged do: [ self changed ].
	self announce: (DCElementAdded element: anElement).
	self changed