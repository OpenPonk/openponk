tests
testPluginReferenceUnknown
	self
		should: [ reader readModelReference: '1234' plugin: 'Unknown' pluginVersion: '0.0.0' ]
		raise: Error