initialization
setupTopMenu
	topMenu := MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'File';
						icon: Smalltalk ui icons openIcon;
						subMenu: self setupSubMenu ] ]