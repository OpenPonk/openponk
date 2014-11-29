tests-serializing
testSerializeDiagramBasic
	| d serialized |
	d := DCDiagram new name: 'Some Diagram'.

	serialized := serializer serializeDiagramBasic: d.
	self assert: (serialized at: #name) = 'Some Diagram'.
	self assert: (serialized at: #className) = 'DCDiagram'.
	self assert: (serialized at: #dcID) = d dcID