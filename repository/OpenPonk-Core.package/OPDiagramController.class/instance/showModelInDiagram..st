construction
showModelInDiagram: aModel
	| controller |
	controller := self newControllerFor: aModel.
	self addController: controller.
	controller showInDiagram: self