controllers management
newControllerFor: aModel
	modelToControllerMapping isDictionary
		ifTrue: [ ^ self newControllerForOld: aModel ].
	^ modelToControllerMapping newControllerFor: aModel