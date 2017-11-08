controllers management
newControllerFor: aModel
	| controller |
	controller := (modelToControllerMapping at: aModel class) new.
	controller model: aModel.
	^ controller