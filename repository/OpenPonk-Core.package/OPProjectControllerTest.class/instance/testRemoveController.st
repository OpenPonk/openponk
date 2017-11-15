tests
testRemoveController
	| dc model |
	dc := OPDiagramController new.
	model := OPTestContainerModel new.
	dc model: model.
	controller addDiagramController: dc.
	controller removeDiagramController: dc.
	self deny: (controller hasModel: model).
	self deny: (model announcer hasSubscriber: controller)