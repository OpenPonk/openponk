tests
testPluginReferenceUnknown
	self
		should: [ reader pluginForName: 'Unknown' pluginVersion: '0.0.0' ]
		raise: Error