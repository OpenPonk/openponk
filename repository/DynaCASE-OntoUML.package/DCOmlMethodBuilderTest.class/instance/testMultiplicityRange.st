tests
testMultiplicityRange
	self parse: '1' rule: #multiplicityRange.
	self assert: result equals: '1'.

	self parse: '1..1' rule: #multiplicityRange.
	self assert: result equals: '1'.

	self parse: '*' rule: #multiplicityRange.
	self assert: result equals: '*'.

	self parse: '0..*' rule: #multiplicityRange.
	self assert: result equals: '*'.

	self parse: '1..2' rule: #multiplicityRange.
	self assert: result equals: '1..2'