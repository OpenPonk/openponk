tests - controllers
testFigureForModel
	controller model: model.
	controller showInDiagram: diagramController.
	self assert: (diagramController figureForModel: model) equals: controller figure