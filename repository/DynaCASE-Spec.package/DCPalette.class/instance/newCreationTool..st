protocol
newCreationTool: aFactoryBlock
	| item tool |
	item := self addItem.
	(tool := DCCreationTool new)
		palette: self;
		factory: aFactoryBlock.
	item action: [ self selectItem: item tool: tool ].
	^ item