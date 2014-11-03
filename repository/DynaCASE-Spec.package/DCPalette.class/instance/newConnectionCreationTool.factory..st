instance creation
newConnectionCreationTool: aLabel factory: aBlock
	| item tool |
	item := self addItem.
	(tool := DCConnectionCreationTool new)
		palette: self;
		factory: aBlock.
	item
		label: aLabel;
		action: [ self selectItem: item tool: tool ]