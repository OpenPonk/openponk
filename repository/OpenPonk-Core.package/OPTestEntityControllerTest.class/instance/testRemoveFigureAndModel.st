tests - destruction
testRemoveFigureAndModel
	diagramController model entities add: model.
	controller model: model.
	controller showInDiagram: diagramController.
	diagramController removeFromView: controller figure.
	self assert: diagramController controllers asArray equals: {}.
	self assert: diagramController model entities asArray equals: {}