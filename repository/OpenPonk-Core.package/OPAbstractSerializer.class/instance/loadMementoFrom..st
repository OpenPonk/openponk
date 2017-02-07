loading
loadMementoFrom: aFolder
	^ OPPersistenceMemento
		model: (self loadModelFrom: aFolder)
		diagram: (self loadDiagramFrom: aFolder)