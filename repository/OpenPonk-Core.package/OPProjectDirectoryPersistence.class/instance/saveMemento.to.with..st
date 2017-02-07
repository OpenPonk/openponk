saving
saveMemento: aMemento to: aRoot with: aSerializer
	| folder |
	folder := aRoot / aMemento uuid asString.
	folder ensureCreateDirectory.
	aSerializer saveMemento: aMemento to: folder