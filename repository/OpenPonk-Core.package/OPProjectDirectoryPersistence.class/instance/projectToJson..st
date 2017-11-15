writing
projectToJson: aProject
	^ STON
		toJsonStringPretty:
			{'project'
				->
					{'name' -> aProject name.
					'uuid' -> aProject uuid asString} asDictionary.
			'exporter'
				->
					{'exporter' -> self exporter.
					'exporterVersion' -> self exporterVersion.
					'timestamp' -> DateAndTime now truncated asString} asDictionary} asDictionary