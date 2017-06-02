protocol
newConnectionCreationTool: aLabel factory: aBlock icon: anIcon
	| item tool |
	item := self addEntry.
	(tool := OPConnectionCreationTool new)
		palette: self;
		factory: aBlock.
	item
		label: aLabel;
		icon: anIcon;
		action: [ self selectItem: item tool: tool ]