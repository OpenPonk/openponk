toolbar
toolbarFor: aGroup
	<DCEditorToolbar: 10000>
	(aGroup addItem: 'Zoom out')
		description: 'Zoom out';
		icon: Smalltalk ui icons dcZoomOutIcon;
		action: [ self zoom: self zoom * 0.8 ].

	(aGroup addItem: '100%')
		description: 'Zoom to 100%';
		icon: Smalltalk ui icons dcZoomIcon;
		action: [ self zoom: 1.0001 ].

	(aGroup addItem: 'Zoom in')
		description: 'Zoom in';
		icon: Smalltalk ui icons dcZoomInIcon;
		action: [ self zoom: self zoom * 1.25 ].

	(aGroup addItem: 'View All')
		description: 'Show whole diagram';
		action: [ self showAllFigures ].

	(aGroup addItem: 'Export')
		description: 'Export diagram as ...';
		subMenu: self exportSubmenu.

	(aGroup addItem: 'Inspect View')
		description: 'Inspect View';
		action: [ self roassalView inspect ]