private
addEntry
	| entry |
	entry := self instantiate: OPPaletteEntry.
	items add: entry.
	^ entry