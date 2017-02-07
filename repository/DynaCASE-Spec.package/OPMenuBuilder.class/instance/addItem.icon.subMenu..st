adding
addItem: aName icon: anIcon subMenu: aMenu
	self group
		addItem: [ :item | 
			item
				name: aName;
				icon: anIcon;
				subMenu: aMenu ]