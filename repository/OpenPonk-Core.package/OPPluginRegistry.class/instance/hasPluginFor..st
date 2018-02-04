accessing
hasPluginFor: aModel
	^ plugins anySatisfy: [ :each | each isPluginFor: aModel ]