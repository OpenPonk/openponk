adding
addItem: aName action: aBlock
	self group
		addItem: [ :item | 
			item
				name: aName;
				action: aBlock ]