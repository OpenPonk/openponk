tests-serializing
testSerializeProject
	| p serialized d serializedDiagram |
	p := DCProject new projectName: 'Some Project'.
	d := DCDiagram new name: 'Some Diagram'.
	p addDiagram: d.
	p
		layouts:
			(Dictionary new
				at: d dcID put: (Dictionary newFromPairs: #(1 10 #@ 10));
				yourself).
	serialized := serializer serializeProject: p.
	serializedDiagram := serializer serializeDiagram: d.
	self assert: (serialized at: #diagrams) size = 1.
	self assert: (serialized at: #diagrams) first = serializedDiagram.
	self assert: (serialized at: #layouts) size = 1.
	self assert: (serialized at: #layouts) keys first = d dcID