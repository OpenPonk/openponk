tests
testExtractOpVersion
	self
		assert: extractor extractOpVersion
		equals:
			{'version' -> OPVersion version.
			'gitCommit' -> OPVersion gitCommit} asDictionary