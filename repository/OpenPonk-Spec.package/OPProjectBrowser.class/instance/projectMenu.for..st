as yet unclassified
projectMenu: aMenu for: aProject
	| menuBuilder |
	aProject ifNil: [ ^ self ].
	menuBuilder := OPMenuBuilder new menu: aMenu.
	menuBuilder
		addItem: 'Remove'
		action: [ aProject removeFromImage.
			self updateRecentList ]