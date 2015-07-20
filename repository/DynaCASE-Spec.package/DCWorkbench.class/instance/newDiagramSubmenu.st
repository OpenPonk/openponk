initialization
newDiagramSubmenu
	^ MenuModel new
		addGroup: [ :group | 
			pluginRegistry
				pluginsDo: [ :each | 
					group
						addItem: [ :item | 
							item
								name: each name;
								icon: each icon;
								action: [ self projectController project addDiagram: (each diagramClass named: 'New Diagram') ] ] ] ]