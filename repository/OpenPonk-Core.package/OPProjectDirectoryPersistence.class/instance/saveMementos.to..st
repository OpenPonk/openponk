saving
saveMementos: aCollection to: aFolder
	aCollection
		do: [ :each | 
			self
				saveMemento: each
				to: aFolder / 'models'
				with: (OPPluginRegistry default pluginFor: each model) serializerClass new ]