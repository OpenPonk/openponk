tests
testParameterList
	self parse: '' rule: #parameterList.
	self assertCollection: result hasSameElements: #().

	self parse: 'param: Type' rule: #parameterList.
	self assertCollection: result hasSameElements: #('param: Type').

	self parse: 'param: Type, param2: Type2' rule: #parameterList.
	self assertCollection: result hasSameElements: #('param: Type' 'param2: Type2')