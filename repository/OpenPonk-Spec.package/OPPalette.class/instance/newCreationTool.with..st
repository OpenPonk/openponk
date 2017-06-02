protocol
newCreationTool: aFactoryBlock with: aToolConfigBlock
	| item tool |
	item := self addEntry.
	(tool := OPCreationTool new)
		palette: self;
		factory: aFactoryBlock.
	item action: [ self selectItem: item tool: tool ].
	aToolConfigBlock value: tool.
	^ item