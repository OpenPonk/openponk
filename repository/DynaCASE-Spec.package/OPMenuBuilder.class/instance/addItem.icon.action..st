adding
addItem: aName icon: anIcon action: aBlock
	self group
		addItem: [ :item | 
			item
				name: aName;
				icon: anIcon;
				action: aBlock ]