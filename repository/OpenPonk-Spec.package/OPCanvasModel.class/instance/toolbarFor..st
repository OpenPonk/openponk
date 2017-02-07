toolbar
toolbarFor: aMenu
	| builder |
	(builder := OPMenuBuilder new) menu: aMenu.
	builder
		addItem: 'Zoom out'
		icon: OPIcons current dcZoomOutIcon
		action: [ self zoom: self zoom * 0.8 ].
	builder addItem: '100%' icon: OPIcons current dcZoomIcon action: [ self zoom: 1.0001 ].
	builder
		addItem: 'Zoom in'
		icon: OPIcons current dcZoomInIcon
		action: [ self zoom: self zoom * 1.25 ].
	builder addItem: 'View All' action: [ self showAllFigures ].
	builder group
		addItem: [ :item | 
			item
				name: 'Undo';
				icon: Smalltalk ui icons smallUndo;
				disable;
				action: [ self diagramController undo ] ];
		addItem: [ :item | 
			item
				name: 'Redo';
				icon: Smalltalk ui icons smallRedo;
				disable;
				action: [ self diagramController redo ] ]

	"	(aGroup addItem: 'Export')
		description: 'Export diagram as ...';
		subMenu: self exportSubmenu.

	(aGroup addItem: 'Inspect View')
		description: 'Inspect View';
		action: [ self roassalView inspect ]"