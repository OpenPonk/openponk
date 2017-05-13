protocol
newModelCreationTool: aFactoryBlock
	| entry |
	entry := self addEntry.
	entry tool: (OPModelCreationTool new palette: self).
	entry factory: aFactoryBlock.
	^ entry