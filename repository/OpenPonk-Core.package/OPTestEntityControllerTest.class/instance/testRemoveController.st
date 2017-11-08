tests - destruction
testRemoveController
	controller model: model.
	controller showInDiagram: diagramController.
	controller removeController.
	self should: [ diagramController controllerForModel: model ] raise: NotFound.
	self assert: diagramController view elements asArray equals: {}