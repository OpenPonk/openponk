as yet unclassified
testCull
	self assert: (adapter cull: #name with: diagram) equals: diagram name.
	self assert: (adapter cull: [ :obj | obj name , '+' ] with: diagram) equals: diagram name , '+'.
	self assert: (adapter cull: 'string' with: diagram) equals: 'string'.
	self assert: (adapter cull: 46 with: diagram) equals: 46