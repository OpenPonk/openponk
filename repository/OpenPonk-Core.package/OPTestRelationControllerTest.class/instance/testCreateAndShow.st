tests - construction
testCreateAndShow
	| subModel sourceController targetController |
	sourceController := diagramController newControllerFor: OPTestEntityModel new.
	sourceController showInDiagram: diagramController.
	targetController := diagramController newControllerFor: OPTestEntityModel new.
	targetController showInDiagram: diagramController.
	controller sourceController: sourceController.
	controller createModelIn: diagramController model andShowInDiagram: diagramController.
	self assert: diagramController model entities isNotEmpty.
	subModel := diagramController model entities first.
	self assert: (diagramController controllers includes: controller).
	self assert: (diagramController view elements includes: controller figure)