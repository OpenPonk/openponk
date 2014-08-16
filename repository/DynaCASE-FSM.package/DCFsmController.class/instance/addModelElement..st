private
addModelElement: aModelElement
	| controller viewElement |
	controller := self createController: aModelElement.
	controller parent: self.
	self controllers add: controller.
	viewElement := controller view.
	(controller isKindOf: DCFsmVertexController)
		ifTrue: [ viewElement @ RTDraggable ].
	self view add: viewElement