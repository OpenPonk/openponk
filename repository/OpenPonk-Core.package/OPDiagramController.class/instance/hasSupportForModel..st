testing
hasSupportForModel: aModel
	modelToControllerMapping isDictionary
		ifTrue: [ ^ modelToControllerMapping includesKey: aModel class ].
	^ modelToControllerMapping hasControllerFor: aModel