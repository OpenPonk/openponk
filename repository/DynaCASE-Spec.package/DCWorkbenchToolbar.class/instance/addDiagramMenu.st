menus
addDiagramMenu
	| builder |
	builder := DCMenuBuilder new.
	DCPluginRegistry default
		pluginsDo:
			[ :each | 
			builder
				addItem: each name
				icon: each icon
				action: [ self project addDiagram: (each diagramClass named: each name) ] ].
	^ builder menu