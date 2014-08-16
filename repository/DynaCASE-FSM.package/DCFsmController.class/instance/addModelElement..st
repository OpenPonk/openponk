adding
addModelElement: anElement
	| controller |
	controller := self createController: anElement.
	controller parent: self.
	self controllers add: controller