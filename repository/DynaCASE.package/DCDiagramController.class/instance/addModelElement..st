adding
addModelElement: aModelElement
	| controller viewElement |
	self model add: aModelElement.
	controller := self createController: aModelElement.
	controller parent: self.
	self controllers add: controller.
	viewElement := controller view.
	viewElement view ifNil: [ self view add: viewElement ].
	^ controller