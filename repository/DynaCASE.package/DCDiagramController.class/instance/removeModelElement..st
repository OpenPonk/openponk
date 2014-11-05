removing
removeModelElement: aModelElement
	| controller |
	controller := self controllerForModel: aModelElement.
	self controllers remove: controller.
	controller remove