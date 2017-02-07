menus
addNewModelMenu
	| menu |
	menu := MenuModel new.
	menu
		addGroup: [ :group | 
			OPPluginRegistry default
				pluginsDo: [ :each | 
					group
						addItem: [ :item | 
							item
								name: each name;
								icon: each icon;
								action: [ (UIManager default request: 'Model name' initialAnswer: each name)
										ifNotNil: [ :name | self project addModel: (each modelClass named: name) ] ] ] ] ].
	^ menu