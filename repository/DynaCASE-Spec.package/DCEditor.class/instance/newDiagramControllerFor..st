diagram handling
newDiagramControllerFor: aDiagram
	| plugin |
	plugin := self workbench pluginRegistry pluginFor: aDiagram.
	^ plugin diagramControllerClass new
		model: aDiagram;
		editor: self;
		yourself