tests
testAddController
	| dc model |
	dc := OPDiagramController new.
	model := OPTestContainerModel new.
	dc model: model.
	controller addDiagramController: dc.
	self assert: controller controllers asArray equals: {dc}.
	self assert: (controller hasModel: model).
	self assert: (model announcer hasSubscriber: controller)