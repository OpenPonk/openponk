specs
addDiagramButtons: aSpecLayout
	DCPluginRegistry default
		pluginsDo:
			[ :each | 
			aSpecLayout
				add: (each diagramClass asString uncapitalized , 'Radio') asSymbol
				height: self buttonHeight ]