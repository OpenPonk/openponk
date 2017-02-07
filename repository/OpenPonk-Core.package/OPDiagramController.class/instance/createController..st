instance creation
createController: aModel
	| controller |
	controller := (self controllerNameFor: aModel) new.
	controller model: aModel.
	^ controller