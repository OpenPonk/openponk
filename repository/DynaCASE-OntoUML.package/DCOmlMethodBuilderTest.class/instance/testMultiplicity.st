tests
testMultiplicity
	self parse: '' rule: #multiplicity.
	self assert: result equals: ''.

	self parse: '[1..2]' rule: #multiplicity.
	self assert: result equals: '[1..2]'