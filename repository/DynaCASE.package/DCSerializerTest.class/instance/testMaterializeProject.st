tests-materializing
testMaterializeProject
	| p serialized d materialized |
	p := DCProject new projectName: 'Some Project'.
	d := DCDiagram new name: 'Some Diagram'.
	p addDiagram: d.
	p
		layouts:
			(Dictionary new
				at: d dcID put: (Dictionary newFromPairs: #(1 10 #@ 10));
				yourself).
	serialized := serializer serializeProject: p.
	serialized := (STON reader
		allowComplexMapKeys: true;
		on: (STON toString: serialized) readStream) next.

	materialized := serializer materializeProject: serialized.

	self assert: materialized diagrams size = 1.
	self assert: materialized diagrams first dcID = d dcID.
	self assert: materialized layouts size = 1.
	self assert: materialized layouts keys first = d dcID