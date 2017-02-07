menus
projectMenu
	| builder |
	builder := OPMenuBuilder new.
	builder
		addItem: 'New project...'
		icon: Smalltalk ui icons openIcon
		action: [ OPProjectBrowser open ].
	builder
		addItem: 'Save'
		icon: Smalltalk ui icons smallSaveIcon
		action: [ OPSaveProjectWindow new
				projectController: self workbench projectController;
				open ].
	builder
		addItem: 'Properties...'
		icon: Smalltalk ui icons tools
		action: [ self workbench projectController project maEdit ].
	builder
		addItem: 'Add new model'
		icon: Smalltalk ui icons smallNewIcon
		subMenu: self addNewModelMenu.
	^ builder menu