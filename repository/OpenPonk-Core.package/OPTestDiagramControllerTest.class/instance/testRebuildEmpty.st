tests - rebuilding
testRebuildEmpty
	diagramController rebuild.
	self assert: diagramController controllers asArray equals: {}