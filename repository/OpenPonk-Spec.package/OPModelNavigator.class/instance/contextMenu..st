toolbar
contextMenu: menu
	tree hasSelectedItem
		ifFalse: [ ^ self ].
	self contextMenuFor: tree selectedItem content in: menu