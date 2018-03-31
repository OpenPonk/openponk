running
testDisplayForProject
	| project |
	project := OPProject new name: 'My Project'.
	self assert: (adapters displayFor: project) equals: 'My Project (Project)'