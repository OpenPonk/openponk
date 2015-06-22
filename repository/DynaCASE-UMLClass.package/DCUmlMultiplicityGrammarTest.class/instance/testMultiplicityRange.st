as yet unclassified
testMultiplicityRange
	self parse: '1..2' rule: #multiplicityRange.
	self parse: '1' rule: #multiplicityRange.
	self parse: '*' rule: #multiplicityRange