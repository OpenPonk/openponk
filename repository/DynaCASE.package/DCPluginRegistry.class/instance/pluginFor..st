accessing
pluginFor: aModel
	^ plugins detect: [ :each | each diagramClass = aModel class ]