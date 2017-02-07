private
doubleClick
	tree hasSelectedItem
		ifFalse: [ ^ self ].
	self openCommand: tree selectedItem content