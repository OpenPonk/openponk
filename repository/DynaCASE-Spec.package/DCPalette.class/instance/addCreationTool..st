protocol
addCreationTool: aBlock
	| item tool |
	item := self addItem.
	(tool := DCCreationTool new) palette: self.
	item action: [ self selectItem: item tool: tool ].
	aBlock value: tool value: item