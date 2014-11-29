tests-materializing
testMaterializeProject
	| p serialized d materialized |
	p := DCProject new projectName: 'Some Project'.
	d := DCDiagram new name: 'Some Diagram'.
	p addDiagram: d.

	serialized := serializer serializeProject: p.
	serialized := STON fromString: (STON toString: serialized).
	materialized := serializer materializeProject: serialized.

	self assert: materialized diagrams size = 1.
	self assert: materialized diagrams first dcID = d dcID