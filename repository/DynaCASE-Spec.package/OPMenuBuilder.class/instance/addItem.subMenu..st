adding
addItem: aName subMenu: aMenu
	self group
		addItem: [ :item | 
			item
				name: aName;
				subMenu: aMenu ]