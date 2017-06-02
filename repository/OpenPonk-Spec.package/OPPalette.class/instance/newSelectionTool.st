private
newSelectionTool
	| item tool |
	item := self addEntry.
	(tool := OPSelectionTool new) palette: self.
	item
		label: 'Select';
		action: [ self selectItem: item tool: tool ];
		icon: OPIcons current dcSelectIcon