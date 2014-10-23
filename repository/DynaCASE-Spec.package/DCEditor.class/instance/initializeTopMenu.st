initialization
initializeTopMenu
	menuModel
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Open';
						description: 'Open file';
						icon: Smalltalk ui icons openIcon;
						action: [ self openCommand ] ].
			group
				addItem: [ :item | 
					item
						name: 'Save';
						description: 'Save File';
						icon: Smalltalk ui icons smallSaveIcon;
						action: [ self saveCommand ] ].
			group
				addItem: [ :item | 
					item
						name: 'Save as...';
						description: 'Save File';
						icon: Smalltalk ui icons smallSaveIcon;
						action: [ self saveAsCommand ] ] ].
	menuModel applyTo: self