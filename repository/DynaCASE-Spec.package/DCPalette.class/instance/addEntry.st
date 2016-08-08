private
addEntry
	| entry |
	entry := self instantiate: DCPaletteEntry.
	items add: entry.
	^ entry