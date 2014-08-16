instance creation
openDiagram: aDiagram
	diagram := aDiagram.
	diagramController := DCFsmController new model: diagram.
	diagramController inspect.
	self reloadView