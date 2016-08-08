private
rightClickMenu: menu
	| el menuBuilder |
	tree hasSelectedItem
		ifFalse: [ ^ self ].
	menuBuilder := DCMenuBuilder new menu: menu.
	el := tree selectedItem content.
	menuBuilder addItem: 'Rename' action: [ self renameCommand: el ].
	menuBuilder addItem: 'Inspect' action: [ self inspectCommand: el ].
	(el isKindOf: DCNamedElement) & (el isKindOf: DCDiagram) not
		& (el className = #DCFsm) not
		ifTrue:
			[ menuBuilder addItem: 'Delete' action: [ self deleteElementCommand: el ] ]
	"menuBuilder addItem: 'Edit' action: [ self editElementCommand: el ]."