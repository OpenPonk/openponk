specs
addDiagramButtons: aSpecLayout
	DCPluginRegistry default
		pluginsDo:
			[ :each | 
			aSpecLayout
				add: (each modelClass asString uncapitalized , 'Radio') asSymbol
				height: self buttonHeight ]