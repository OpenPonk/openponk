as yet unclassified
projectMenu: aMenu
	| project menuBuilder |
	project := recentList selectedItem ifNil: [ ^ self ].
	menuBuilder := OPMenuBuilder new menu: aMenu.
	menuBuilder
		addItem: 'Remove'
		action:
			[ project removeFromImage.
			recentList
				items: OPProjectStorage default projects;
				updateList ]