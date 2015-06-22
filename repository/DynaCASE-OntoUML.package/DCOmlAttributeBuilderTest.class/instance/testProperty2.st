tests
testProperty2
	self parse: '+prop: Type[1..2]' rule: #property.
	self assert: (result isMemberOf: Attribute).
	self assert: result name equals: 'prop'.
	self assert: result dataType equals: 'Type'.
	self assert: result multiplicity equals: '1..2'