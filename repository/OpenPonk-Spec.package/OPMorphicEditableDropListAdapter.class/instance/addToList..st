factory
addToList: anItem
	self model addSilentlyItemLabeled: anItem do: [  ].
	self model setSelectedItem: anItem