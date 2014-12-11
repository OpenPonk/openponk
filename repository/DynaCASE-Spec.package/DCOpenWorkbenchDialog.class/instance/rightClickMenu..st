initialization
rightClickMenu: menu
	| el menuBuilder |
	recentProjectsList hasSelectedItem
		ifFalse: [ ^ self ].
	menuBuilder := DCMenuBuilder new menu: menu.
	el := recentProjectsList selectedItem content.
	menuBuilder addItem: 'Delete' action: [ self inspect: el ]