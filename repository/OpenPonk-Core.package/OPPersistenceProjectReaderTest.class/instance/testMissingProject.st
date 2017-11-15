tests
testMissingProject
	self should: [ reader fromFolder: FileSystem memory root ] raise: FileDoesNotExist