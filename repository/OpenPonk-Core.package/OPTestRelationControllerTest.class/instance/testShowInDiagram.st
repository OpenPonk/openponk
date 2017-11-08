tests - construction
testShowInDiagram
	controller model: model.
	controller showInDiagram: diagramController.
	self assert: (diagramController controllerForFigure: controller figure) equals: controller