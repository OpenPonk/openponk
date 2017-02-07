tests
testReadProject
	project := reader readProjectFrom: root / 'project.xml'.
	self assert: project name equals: 'Test Project'.
	self
		assert: project uuid
		equals: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c').
	self assert: project storageFolder equals: root