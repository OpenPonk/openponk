tests
testReadProject
	| project |
	project := reader readProjectFrom: root / 'project.xml'.
	self assert: project name equals: 'Test Project'