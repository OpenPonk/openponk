initialization
initializeTopMenu
	menuModel
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Open file';
						icon: Smalltalk ui icons openIcon;
						action: [ self openCommand ] ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Save File';
						icon: Smalltalk ui icons smallSaveIcon;
						action: [ self saveAsCommand ] ].
			group
				addItem: [ :item | 
					item
						name: nil;
						description: 'Print file';
						icon: Smalltalk ui icons smallPrintIcon;
						action: [ self inform: 'Print diagram' ] ] ].
	menuModel applyTo: self