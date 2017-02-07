saving
saveMemento: aMemento to: aFolder
	(aFolder / #models / aMemento uuid asString) ensureCreateDirectory.
	(self pluginFor: aMemento model) serializerClass new
		export: aMemento
		to: aFolder / #models / aMemento uuid asString