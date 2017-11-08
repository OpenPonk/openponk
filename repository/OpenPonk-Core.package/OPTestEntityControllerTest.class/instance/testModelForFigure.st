tests - controllers
testModelForFigure
	controller model: model.
	controller showInDiagram: diagramController.
	self assert: (diagramController modelForFigure: controller figure) equals: model