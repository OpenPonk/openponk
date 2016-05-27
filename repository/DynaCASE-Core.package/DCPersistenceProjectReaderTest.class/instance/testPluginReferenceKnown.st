tests
testPluginReferenceKnown
	self
		assert: {(reader readModelReference: '1234' plugin: 'DCTestPlugin' pluginVersion: '0.0.0')}
		equals: DCPluginRegistry default plugins asArray