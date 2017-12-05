tests
testPluginReferenceKnown
	self
		assert: {reader pluginForName: #OPTestPlugin pluginVersion: OPTestPlugin new version}
		equals: OPPluginRegistry default plugins asArray