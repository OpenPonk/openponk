tests
testPluginReferenceKnown
	self
		assert: {(reader pluginForName: #OPTestPlugin pluginVersion: '0.0.0')}
		equals: OPPluginRegistry default plugins asArray