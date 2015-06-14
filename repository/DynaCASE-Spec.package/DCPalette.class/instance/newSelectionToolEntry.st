private
newSelectionToolEntry
	| entry tool |
	(tool := DCSelectionTool new) palette: self.

	(entry := DCPaletteEntry new)
		tool: DCSelectionTool new;
		label: 'Select';
		action: [ self selectItem: entry tool: tool ];
		icon: Smalltalk ui icons dcSelectIcon.
		
	items add: entry