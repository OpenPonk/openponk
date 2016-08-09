tests
testReadProject
	project := reader readProjectFrom: root / 'project.xml'.
	self assert: project name equals: 'Test Project'.
	self assert: project storageFolder equals: root