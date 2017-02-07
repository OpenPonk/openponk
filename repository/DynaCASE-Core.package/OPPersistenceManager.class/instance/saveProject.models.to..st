saving
saveProject: aProjectMemento models: modelMementos to: aFolder
	(aFolder / aProjectMemento projectFile) asFileReference
		writeStreamDo:
			[ :stream | stream nextPutAll: (STON toJsonStringPretty: aProjectMemento projectDescription) ].
	modelMementos do: [ :each | self saveMemento: each to: aFolder ]