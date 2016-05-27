tests
testMissingProject
	self should: [ reader fromDirectory: FileSystem memory root ] raise: FileDoesNotExist