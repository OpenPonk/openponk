controllers management
newControllerFor: aModel
	modelToControllerMapping isDictionary
		ifTrue: [ ^ self newControllerFor: aModel ].
	^ modelToControllerMapping newControllerFor: aModel