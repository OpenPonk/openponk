writing
modelReferencesToJson: models
	| references |
	references := models asArray
		collect: [ :each | 
			| plugin |
			plugin := OPPluginRegistry default pluginFor: each.
			{'uuid' -> each uuid asString.
			'plugin' -> plugin className.
			'pluginVersion' -> plugin version} asDictionary ].
	^ STON toJsonStringPretty: references