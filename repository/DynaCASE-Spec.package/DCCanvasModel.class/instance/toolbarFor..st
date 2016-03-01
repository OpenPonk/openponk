toolbar
toolbarFor: aMenu
	| builder |
	(builder := DCMenuBuilder new) menu: aMenu.
	builder
		addItem: 'Zoom out'
		icon: DCIcons current dcZoomOutIcon
		action: [ self zoom: self zoom * 0.8 ].
	builder addItem: '100%' icon: DCIcons current dcZoomIcon action: [ self zoom: 1.0001 ].
	builder
		addItem: 'Zoom in'
		icon: DCIcons current dcZoomInIcon
		action: [ self zoom: self zoom * 1.25 ].

	builder addItem: 'View All' action: [ self showAllFigures ]

	"	(aGroup addItem: 'Export')
		description: 'Export diagram as ...';
		subMenu: self exportSubmenu.

	(aGroup addItem: 'Inspect View')
		description: 'Inspect View';
		action: [ self roassalView inspect ]"