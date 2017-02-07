saving
saveModel: aMemento to: aFolder
	(aFolder / 'model' , self modelExtension)
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: (self serializeModel: aMemento model) ]