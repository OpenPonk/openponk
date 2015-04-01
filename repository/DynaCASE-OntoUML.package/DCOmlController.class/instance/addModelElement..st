adding
addModelElement: aModelElement
	| controller figure |
	self controllers detect: [ :ctrl | ctrl model = aModelElement ] ifFound: [ ^ self ].
	(self model has: aModelElement)
		ifFalse: [ self model add: aModelElement ].
	controller := self createController: aModelElement.
	controller diagramController: self.
	self controllers add: controller.
	(controller isKindOf: DCOmlGeneralizationController)
		ifTrue: [ 
			| fromModel toModel fromCtrl toCtrl |
			fromModel := aModelElement child.
			toModel := aModelElement parent.
			fromCtrl := self controllers detect: [ :ctrl | ctrl model = fromModel ] ifNone: [ self addModelElement: fromModel ].
			toCtrl := self controllers detect: [ :ctrl | ctrl model = toModel ] ifNone: [ self addModelElement: toModel ].
			controller
				source: fromCtrl;
				target: toCtrl ].
	(controller isKindOf: DCOmlGeneralizationController) not & (controller isKindOf: DCOmlRelationshipController)
		ifTrue: [ 
			| fromModel toModel fromCtrl toCtrl |
			fromModel := aModelElement start.
			toModel := aModelElement end.
			fromCtrl := self controllers detect: [ :ctrl | ctrl model = fromModel ] ifNone: [ self addModelElement: fromModel ].
			toCtrl := self controllers detect: [ :ctrl | ctrl model = toModel ] ifNone: [ self addModelElement: toModel ].
			controller
				source: fromCtrl;
				target: toCtrl ].
	figure := controller figure.
	figure view ifNil: [ figure renderIn: self view ].
	controller refreshFigure.
	^ controller