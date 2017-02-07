specs
addDiagramButtons: aSpecLayout
	OPPluginRegistry default
		pluginsDo:
			[ :each | 
			aSpecLayout
				add: (each modelClass asString uncapitalized , 'Radio') asSymbol
				height: self buttonHeight ]