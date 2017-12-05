tests
testExtractUser
	self
		assert: extractor extractUser
		equals: {'uuid' -> OPTelemetry uuid asString} asDictionary