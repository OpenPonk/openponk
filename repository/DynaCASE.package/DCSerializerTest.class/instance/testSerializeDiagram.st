tests-serializing
testSerializeDiagram
	| d serialized el1 el2 elements |
	d := DCDiagram new name: 'Some Diagram'.
	el1 := DCNamedElement new name: 'First Element'.
	el2 := DCNamedElement new name: 'Second Element'.
	d
		add: el1;
		add: el2.

	serialized := serializer serializeDiagram: d.
	serialized := STON fromString: (STON toString: serialized).

	elements := serialized at: #elements.
	self assert: elements size = 2.
	self assert: elements first dcID = el1 dcID.
	self assert: elements second dcID = el2 dcID