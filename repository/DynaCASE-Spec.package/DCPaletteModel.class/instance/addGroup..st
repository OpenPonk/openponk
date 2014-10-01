protocol
addGroup: aBlock
	| group |
	group := self instantiate: DCPaletteGroupModel.
	aBlock value: group.
	self addPaletteGroup: group