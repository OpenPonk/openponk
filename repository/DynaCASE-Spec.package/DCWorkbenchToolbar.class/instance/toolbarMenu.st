menus
toolbarMenu
	| builder |
	(builder := DCMenuBuilder new) menu: toolbar.
	builder addItem: 'Project' icon: Smalltalk ui icons openIcon subMenu: self projectMenu.
	builder addItem: 'Editor' icon: Smalltalk ui icons packageIcon subMenu: self editorMenu