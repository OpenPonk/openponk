tests
testReturnValue
	self parse: ':Type' rule: #returnValue.
	self assert: result equals: 'Type'.

	self parse: ':Type[1..2]' rule: #returnValue.
	self assert: result equals: 'Type[1..2]'