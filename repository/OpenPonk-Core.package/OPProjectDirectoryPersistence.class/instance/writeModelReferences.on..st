writing
writeModelReferences: models on: aStream
	(XMLWriter on: aStream)
		writeWith: [ :writer | 
			writer
				enablePrettyPrinting;
				xml;
				tag: 'models'
					with: [ models
						do: [ :each | 
							| plugin |
							plugin := OPPluginRegistry default pluginFor: each.
							writer
								tag: 'model'
								attributes:
									(Dictionary
										with: #id -> each uuid asString
										with: #plugin -> plugin className
										with: #pluginVersion -> plugin version) ] ] ]