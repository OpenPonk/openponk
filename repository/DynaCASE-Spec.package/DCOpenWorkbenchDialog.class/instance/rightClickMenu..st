initialization
rightClickMenu: menu
	| el menuBuilder |
	recentProjectsList selectedItem ifNil: [ ^ self ].
	menuBuilder := DCMenuBuilder new menu: menu.
	el := recentProjectsList selectedItem.
	menuBuilder
		addItem: 'Remove from list'
		action: [ 
			self class RecentProjects remove: el.
			self updateRecentProjects ]