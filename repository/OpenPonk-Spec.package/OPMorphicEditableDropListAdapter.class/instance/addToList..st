factory
addToList: anItem
	self model addItemLabeled: anItem do: [  ].
	self model setSelectedItem: anItem