initialization
buildToolbar: aMenu
	aMenu
		addGroup:
			[ :group | 
			group
				addItem:
						[ :item | 
					item
						name: 'New';
						description: 'New Diagram';
						icon: Smalltalk ui icons addIcon;
						action: [ self class new openWithSpec ] ];
				addItem:
						[ :item | 
					item
						name: 'Save';
						description: 'Save Diagram';
						icon: Smalltalk ui icons smallSaveIcon;
						action: [ self saveToFile: location ] ];
				addItem:
						[ :item | 
					item
						name: 'Save as...';
						description: 'Save Diagram As...';
						icon: Smalltalk ui icons smallSaveIcon;
						action: [ self saveToFile: nil ] ];
				addItem:
						[ :item | 
					item
						name: 'Open';
						description: 'Open...';
						icon: Smalltalk ui icons openIcon;
						action: [ self openFromFile ] ];
				addItem:
						[ :item | 
					item
						name: 'Open Editor';
						description: 'Open Editor';
						icon: Smalltalk ui icons openIcon;
						action: [ model ifNil: [ self updateModel ].
							OPWorkbench openModel: model ] ] ]