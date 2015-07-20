adding
addItem: aLabel
	| item |
	item := MenuItemModel new.
	item name: aLabel.
	groupModel addMenuItem: item.
	^ item