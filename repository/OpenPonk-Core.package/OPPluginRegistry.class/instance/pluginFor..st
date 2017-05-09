accessing
pluginFor: aModel
	^ plugins detect: [ :each | each isPluginFor: aModel ]