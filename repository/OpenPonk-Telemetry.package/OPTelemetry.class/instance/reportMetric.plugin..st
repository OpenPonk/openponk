reporting
reportMetric: aPayload plugin: aPlugin
	| data |
	self enabled
		ifFalse: [ ^ self ].
	data := OPTelemetryExtractor new metadataFor: aPlugin.
	data at: #payload put: aPayload asDictionary.
	self send: data