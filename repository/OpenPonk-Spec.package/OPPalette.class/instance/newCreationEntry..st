protocol
newCreationEntry: aFactoryBlock
	| entry |
	entry := self addEntry.
	entry tool: (OPCreationTool new palette: self).
	entry factory: aFactoryBlock.
	^ entry