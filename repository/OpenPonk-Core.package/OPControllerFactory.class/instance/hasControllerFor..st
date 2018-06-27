api - testing
hasControllerFor: aModel
	^ registrations anySatisfy: [ :each | each isForModel: aModel ]