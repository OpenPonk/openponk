tests
testProjectFile
	| result resultString |
	resultString := String
		streamContents: [ :stream | 
			stream
				<<
					(persistence
						projectToJson:
							(OPProject new
								name: 'My Project';
								uuid: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c'))) ].
	result := STON fromString: resultString.
	(result at: 'exporter') at: 'timestamp' put: '0'.
	self
		assert: result
		equals:
			{'project'
				->
					{'name' -> 'My Project'.
					'uuid' -> '7f5ee44a-1655-4061-a78e-db9578a2226c'} asDictionary.
			'exporter'
				->
					{'exporter' -> 'OpenPonk'.
					'exporterVersion' -> OPVersion version.
					'timestamp' -> '0'} asDictionary} asDictionary