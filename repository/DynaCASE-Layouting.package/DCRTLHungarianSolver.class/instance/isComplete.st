helpers
isComplete
	^ (columnCovers select: [ :each | each = true ]) size = size