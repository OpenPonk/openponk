saving
saveState: saveData to: aFile
	aFile
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: (STON toJsonStringPretty: saveData) ]