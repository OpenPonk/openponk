tests
testExtractMetadata
	extractor stub extractVersion willReturn: 'ph-version'.
	extractor stub extractOpVersion willReturn: 'op-version'.
	extractor stub extractOpPluginVersions willReturn: 'op-plugins-versions'.
	extractor stub extractUser willReturn: 'user-data'.
	self
		assert: extractor extractMetadata
		equals:
			{#pharo -> 'ph-version'.
			#openponk -> 'op-version'.
			#plugins -> 'op-plugins-versions'.
			#auto -> SlReporter autoSubmit.
			#user -> 'user-data'} asDictionary