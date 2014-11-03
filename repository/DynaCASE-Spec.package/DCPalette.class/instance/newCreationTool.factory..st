instance creation
newCreationTool: aLabel factory: aBlock
	| item tool |
	item := self addItem.
	(tool := DCCreationTool new)
		palette: self;
		factory: aBlock.
	item
		label: aLabel;
		action: [ self selectItem: item tool: tool ]