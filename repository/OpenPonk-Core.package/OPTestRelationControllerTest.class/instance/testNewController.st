tests - controllers
testNewController
	controller := diagramController newControllerFor: model.
	self assert: controller class equals: self controllerClass