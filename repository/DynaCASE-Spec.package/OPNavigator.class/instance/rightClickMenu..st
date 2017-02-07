private
rightClickMenu: menu
	| el menuBuilder |
	tree hasSelectedItem
		ifFalse: [ ^ self ].
	menuBuilder := OPMenuBuilder new menu: menu.
	el := tree selectedItem content.
	menuBuilder addItem: 'Rename' action: [ self renameCommand: el ].
	menuBuilder addItem: 'Inspect' action: [ self inspectCommand: el ].
	(el isKindOf: OPNamedElement) & (el isKindOf: OPDiagram) not
		& (el className = #DCFsm) not
		ifTrue:
			[ menuBuilder addItem: 'Delete' action: [ self deleteElementCommand: el ] ]
	"menuBuilder addItem: 'Edit' action: [ self editElementCommand: el ]."