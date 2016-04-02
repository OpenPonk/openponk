accessing
modelsWithPlugins
	^ (project models
		collect: [ :each | each uuid asString -> (DCPluginRegistry default pluginFor: each) className ])
		asDictionary