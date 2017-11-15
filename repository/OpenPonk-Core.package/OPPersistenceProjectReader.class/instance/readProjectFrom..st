reading
readProjectFrom: aFile
	| project json exporter exporterVersion |
	json := STON fromStream: aFile readStream.
	exporter := (json at: 'exporter') at: 'exporter'.
	exporterVersion := (json at: 'exporter') at: 'exporterVersion'.
	(exporter = self exporter and: [ exporterVersion = exporterVersion ])
		ifFalse: [ self error: 'Unsupported exporter ' , exporter , ' version ' , exporterVersion ].
	project := OPProject new.
	project name: ((json at: 'project') at: 'name').
	project uuid: (UUID fromString: ((json at: 'project') at: 'uuid')).
	project storageFolder: aFile parent.
	^ project