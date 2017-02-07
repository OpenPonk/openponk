diagram handling
newDiagramControllerFor: aModel
	| plugin |
	plugin := self workbench pluginRegistry pluginFor: aModel.
	^ plugin diagramControllerClass new
		model: aModel;
		editor: self;
		yourself