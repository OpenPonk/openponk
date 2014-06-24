initialization
setupSubMenu
	^ MenuModel new
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Open';
						icon: Smalltalk ui icons openIcon;
						shortcut: $o command;
						action: [ self inform: 'Open' ] ].
			group
				addItem: [ :item | 
					item
						name: 'Save';
						icon: Smalltalk ui icons smallSaveIcon;
						shortcut: $s command;
						action: [ self inform: 'Save' ] ] ]