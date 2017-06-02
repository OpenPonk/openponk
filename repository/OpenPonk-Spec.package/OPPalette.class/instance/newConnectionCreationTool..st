protocol
newConnectionCreationTool: aFactoryBlock
	| item tool |
	item := self addEntry.
	(tool := OPConnectionCreationTool new)
		palette: self;
		factory: aFactoryBlock.
	item action: [ self selectItem: item tool: tool ].
	^ item