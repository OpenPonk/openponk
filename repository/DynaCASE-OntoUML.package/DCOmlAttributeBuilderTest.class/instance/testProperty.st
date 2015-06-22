tests
testProperty
	self parse: 'prop' rule: #property.
	self assert: (result isMemberOf: Attribute).
	self assert: result name equals: 'prop'.
	self assert: result dataType equals: nil.
	self assert: result multiplicity equals: ''