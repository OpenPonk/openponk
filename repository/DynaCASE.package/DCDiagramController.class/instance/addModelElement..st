adding
addModelElement: aModelElement
	| controller viewElement |
	(self model has: aModelElement)
		ifFalse: [ self model add: aModelElement ].
	controller := self createController: aModelElement.
	controller parent: self.
	self controllers add: controller.
	viewElement := controller view.
	viewElement view ifNil: [ self view add: viewElement ].
	self view add: controller activationView.
	controller view
		when: TRMouseEnter
		do: [ :event | 
			(self findControllerByView: event element) activateLevel: 10 color: Color gray.
			self updateView ].
	controller view
		when: TRMouseLeave
		do: [ :event | 
			(self findControllerByView: event element) deactivateLevel: 10.
			self updateView ].
	^ controller