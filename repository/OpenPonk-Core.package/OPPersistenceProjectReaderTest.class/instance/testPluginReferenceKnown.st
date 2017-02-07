tests
testPluginReferenceKnown
	self
		assert: {(reader readModelReference: '1234' plugin: #OPTestPlugin pluginVersion: '0.0.0')}
		equals: OPPluginRegistry default plugins asArray