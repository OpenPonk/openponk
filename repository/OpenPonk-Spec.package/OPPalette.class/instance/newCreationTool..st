protocol
newCreationTool: aFactoryBlock
	| item tool |
	item := self addEntry.
	(tool := OPCreationTool new)
		palette: self;
		factory: aFactoryBlock.
	item action: [ self selectItem: item tool: tool ].
	^ item