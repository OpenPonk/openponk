private
newSelectionTool
	| item tool |
	item := self addEntry.
	(tool := OPSelectionTool new) palette: self.
	item
		label: 'Select';
		action: [ self selectItem: item tool: tool ];
		shortcut: Character escape asKeyCombination;
		icon: OPIcons current dcSelectIcon