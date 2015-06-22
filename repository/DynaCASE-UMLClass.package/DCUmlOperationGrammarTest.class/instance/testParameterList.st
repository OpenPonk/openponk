tests
testParameterList
	self parse: '' rule: #parameterList.
	self parse: 'name: Type' rule: #parameterList.
	self parse: 'name: Type, name2: Type2' rule: #parameterList