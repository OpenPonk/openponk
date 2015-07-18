ui-extensions
toolbarForEditor: anEditor inGroup: aGroup
	(aGroup addItem: 'Simulation')
		action: [ DCFsmSimulator new openOn: anEditor diagramController ]