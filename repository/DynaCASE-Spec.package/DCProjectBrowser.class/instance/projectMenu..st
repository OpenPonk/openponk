as yet unclassified
projectMenu: aMenu
	| project menuBuilder |
	project := recentList selectedItem ifNil: [ ^ self ].
	menuBuilder := DCMenuBuilder new menu: aMenu.
	menuBuilder
		addItem: 'Remove'
		action:
			[ project removeFromImage.
			recentList
				items: DCProjectStorage default projects;
				updateList ]