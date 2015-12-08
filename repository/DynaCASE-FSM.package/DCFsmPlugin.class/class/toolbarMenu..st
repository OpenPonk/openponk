toolbar
toolbarMenu: aBuilder
	(aBuilder item: 'Open Simulator...')
		action: [ DCFsmSimulator new openOn: aBuilder model diagramController ]