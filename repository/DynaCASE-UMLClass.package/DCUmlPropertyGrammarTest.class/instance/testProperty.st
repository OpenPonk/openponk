tests
testProperty
	self parse: 'name' rule: #property.
	self parse: '+name: Type' rule: #property.
	self parse: '+name: Type[1..2]' rule: #property