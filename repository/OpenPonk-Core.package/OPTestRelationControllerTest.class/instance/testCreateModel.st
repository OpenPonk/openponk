tests - construction
testCreateModel
	| sourceController targetController |
	sourceController := diagramController newControllerFor: OPTestEntityModel new.
	sourceController showInDiagram: diagramController.
	targetController := diagramController newControllerFor: OPTestEntityModel new.
	targetController showInDiagram: diagramController.
	controller sourceController: sourceController.
	controller createModelIn: targetController model.
	self assert: controller model isNotNil.
	self assert: controller model source equals: sourceController model.
	self assert: controller model target equals: targetController model