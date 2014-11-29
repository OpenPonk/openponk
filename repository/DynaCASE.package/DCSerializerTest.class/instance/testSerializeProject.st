tests-serializing
testSerializeProject
	| p serialized d serializedDiagram |
	p := DCProject new projectName: 'Some Project'.
	d := DCDiagram new name: 'Some Diagram'.
	p addDiagram: d.

	serialized := serializer serializeProject: p.
	serializedDiagram := serializer serializeDiagram: d.
	self assert: (serialized at: #diagrams) size = 1.
	self assert: (serialized at: #diagrams) first = serializedDiagram