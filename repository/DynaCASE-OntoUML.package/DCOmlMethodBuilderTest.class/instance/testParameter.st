tests
testParameter
	self parse: 'param: Type' rule: #parameter.
	self assert: result equals: 'param: Type'.

	self parse: 'param: Type[1]' rule: #parameter.
	self assert: result equals: 'param: Type[1]'