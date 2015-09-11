protocol
newConnectionCreationTool: aFactoryBlock
	| item tool |
	item := self addItem.
	(tool := DCConnectionCreationTool new)
		palette: self;
		factory: aFactoryBlock.
	item action: [ self selectItem: item tool: tool ].
	^ item