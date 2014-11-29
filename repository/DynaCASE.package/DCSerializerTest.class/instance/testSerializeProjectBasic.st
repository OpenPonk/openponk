tests-serializing
testSerializeProjectBasic
	| p serialized |
	p := DCProject new.
	p projectName: 'Some Project'.

	serialized := serializer serializeProjectBasic: p.
	self assert: (serialized at: #projectName) = 'Some Project'