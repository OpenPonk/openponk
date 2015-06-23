tests
testVisibility
	self parse: '+' rule: #visibility.
	self parse: '-' rule: #visibility.
	self parse: '#' rule: #visibility.
	self parse: '~' rule: #visibility