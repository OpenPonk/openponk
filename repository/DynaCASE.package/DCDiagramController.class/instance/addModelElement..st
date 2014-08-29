as yet unclassified
addModelElement: aModelElement
	| controller viewElement |
	controller := self createController: aModelElement.
	controller parent: self.
	self controllers add: controller.
	viewElement := controller view.
	self view add: viewElement