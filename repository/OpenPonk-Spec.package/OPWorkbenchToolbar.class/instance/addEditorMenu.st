menus for editor
addEditorMenu
	self removeEditorMenu.
	toolbar
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Editor';
						icon: Smalltalk ui icons packageIcon;
						subMenu: self editorMenu ] ]