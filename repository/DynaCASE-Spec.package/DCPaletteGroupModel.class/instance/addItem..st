protocol
addItem: aBlock
	| item |
	item := DCPaletteItemModel new.
	aBlock value: item.
	self addPaletteItem: item