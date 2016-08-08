protocol
newCreationEntry: aFactoryBlock
	| entry |
	entry := self addEntry.
	entry tool: (DCCreationTool new palette: self).
	entry factory: aFactoryBlock.
	^ entry