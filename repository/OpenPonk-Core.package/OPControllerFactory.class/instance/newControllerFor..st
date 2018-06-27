api - accessing
newControllerFor: aModel
	| controller |
	controller := (registrations detect: [ :each | each isForModel: aModel ]) controllerClass
		new.
	controller model: aModel.
	^ controller