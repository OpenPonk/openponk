figures
showModelInDiagram: aModel
	self controllerForModel: aModel ifFound: [ :ctrl | ^ ctrl ].
	^ (self newControllerFor: aModel)
		showInDiagram: self;
		yourself