protocol
newConnectionCreationEntry: aFactoryBlock
	| entry |
	entry := self addEntry.
	entry tool: (OPConnectionCreationTool new palette: self).
	entry factory: aFactoryBlock.
	^ entry