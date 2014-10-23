initialization
initializeTopMenu
	menuModel
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Open';
						description: 'Open Project';
						icon: Smalltalk ui icons openIcon;
						action: [ self openCommand ] ].
			group
				addItem: [ :item | 
					item
						name: 'Save';
						description: 'Save Project';
						icon: Smalltalk ui icons smallSaveIcon;
						action: [ self saveCommand ] ] ].
	menuModel applyTo: self