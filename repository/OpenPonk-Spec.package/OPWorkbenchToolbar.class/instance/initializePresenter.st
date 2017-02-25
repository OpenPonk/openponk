initialization
initializePresenter
	toolbar
		autoRefresh: true;
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Project';
						icon: Smalltalk ui icons openIcon;
						subMenu: self projectMenu ] ].
	toolbar applyTo: self