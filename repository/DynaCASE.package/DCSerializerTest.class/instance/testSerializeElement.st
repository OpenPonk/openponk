tests-serializing
testSerializeElement
	| e serialized |
	e := DCNamedElement new name: 'Some Element'.

	serialized := serializer serializeElement: e.
	self assert: serialized = e