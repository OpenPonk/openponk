adding
hasModel: aModel
	^ controllers anySatisfy: [ :each | each model = aModel ]