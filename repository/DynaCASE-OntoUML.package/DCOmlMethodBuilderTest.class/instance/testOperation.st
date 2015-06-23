tests
testOperation
	self parse: 'anOperation()' rule: #operation.
	self assert: (result isMemberOf: Method).
	self assert: result name equals: 'anOperation'.
	self assert: result parameters isEmpty.
	self assert: result returnDataType equals: nil