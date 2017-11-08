tests - construction
testFigureWasRendered
	controller model: model.
	controller showInDiagram: diagramController.
	self assert: (diagramController view elements includes: controller figure)