menus
addDiagramMenu
	| menu |
	menu := MenuModel new.
	menu
		addGroup: [ :group | 
			DCPluginRegistry default
				pluginsDo: [ :each | 
					group
						addItem: [ :item | 
							item
								name: each name;
								icon: each icon;
								action: [ self project addModel: (each modelClass named: each name) ] ] ] ].
	^ menu