toolbar
toolbarFor: aMenu
	| builder |
	(builder := DCMenuBuilder new) menu: aMenu.
	builder
		addItem: 'Zoom out'
		icon: Smalltalk ui icons dcZoomOutIcon
		action: [ self zoom: self zoom * 0.8 ].
	builder addItem: '100%' icon: Smalltalk ui icons dcZoomIcon action: [ self zoom: 1.0001 ].
	builder
		addItem: 'Zoom in'
		icon: Smalltalk ui icons dcZoomInIcon
		action: [ self zoom: self zoom * 1.25 ].

	builder addItem: 'View All' action: [ self showAllFigures ]

	"	(aGroup addItem: 'Export')
		description: 'Export diagram as ...';
		subMenu: self exportSubmenu.

	(aGroup addItem: 'Inspect View')
		description: 'Inspect View';
		action: [ self roassalView inspect ]"