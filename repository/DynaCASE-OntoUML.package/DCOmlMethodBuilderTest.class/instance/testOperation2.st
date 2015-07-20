tests
testOperation2
	self parse: 'anOperation(param1: Type[*], param2: Type2): ReturnType[1..2]' rule: #operation.
	self assert: (result isMemberOf: Method).
	self assert: result name equals: 'anOperation'.
	self assertCollection: result parameters hasSameElements: #('param1: Type[*]' 'param2: Type2').
	self assert: result returnDataType equals: 'ReturnType[1..2]'