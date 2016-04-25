as yet unclassified
writeProject: aProject on: aStream
	(XMLWriter on: aStream)
		writeWith: [ :writer | 
			writer
				enablePrettyPrinting;
				xml;
				tag: 'project'
					with: [ writer tag: 'name' with: aProject name.
					writer
						tag: 'documentation'
						with: [ writer
								tag: 'exporter' with: self exporter;
								tag: 'exporterVersion' with: self exporterVersion;
								tag: 'timestamp' with: DateAndTime now truncated asString ] ] ]