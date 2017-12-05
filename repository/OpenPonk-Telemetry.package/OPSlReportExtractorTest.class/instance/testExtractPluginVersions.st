tests
testExtractPluginVersions
	OPPluginRegistry stub default willReturn: registry.
	self
		assert: extractor extractOpPluginVersions
		equals:
			{{#name -> 'Plugin for testing'.
			#className -> 'OPTestPlugin'.
			#version -> '0.1.0-beta.2'.
			#gitCommit -> OPVersion gitCommit} asDictionary}