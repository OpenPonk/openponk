loading
loadMementoFrom: aFolder
	^ DCPersistenceMemento
		model: (self loadModelFrom: aFolder)
		diagram: (self loadDiagramFrom: aFolder)