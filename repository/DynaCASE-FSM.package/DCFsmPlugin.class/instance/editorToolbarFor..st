ui-extensions
editorToolbarFor: aGroup
	(aGroup addItem: 'Simulation')
		description: '';
		action: [ DCFsmSimulator new openOn: self diagramController ]