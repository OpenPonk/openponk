convenience
materializeMementoFrom: aString
	| unwrapped |
	unwrapped := (STON reader
		allowComplexMapKeys: true;
		on: aString readStream) next.
	^ OPPersistenceMemento
		model: (self materializeModelFrom: (unwrapped at: #model))
		diagram: (self materializeDiagramFrom: (unwrapped at: #diagram))