tests
testParameter
	self parse: 'name: Type' rule: #parameter.
	self parse: 'name: Type[1..2]' rule: #parameter