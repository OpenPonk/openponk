removing
removeHandle
	element
		ifNotNil:
			[ element connectedEdges removeAll.
			element trachelShape callbacks removeAll.
			element remove.
			element := nil ]