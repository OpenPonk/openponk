menus
projectMenu
	| builder |
	builder := DCMenuBuilder new.
	builder
		addItem: 'New project...'
		icon: Smalltalk ui icons openIcon
		action: [ DCProjectBrowser open ].
	builder
		addItem: 'Save'
		icon: Smalltalk ui icons smallSaveIcon
		action: [ self workbench projectController saveProject ].
	builder
		addItem: 'Properties...'
		icon: Smalltalk ui icons tools
		action: [ self workbench projectController project maEdit ].
	builder
		addItem: 'Add diagram'
		icon: Smalltalk ui icons smallNewIcon
		subMenu: self addDiagramMenu.
	^ builder menu