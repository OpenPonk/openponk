accessing
pluginFor: aModel
	^ plugins detect: [ :each | each modelClass = aModel class ]