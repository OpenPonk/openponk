tests-materializing
testMaterializeDiagram
	| d serialized el1 el2 materialized str serialized2 |
	d := DCDiagram new name: 'Some Diagram'.
	el1 := DCNamedElement new name: 'First Element'.
	el2 := DCNamedElement new name: 'Second Element'.
	d
		add: el1;
		add: el2.

	serialized := serializer serializeDiagram: d.
	str := STON toStringPretty: serialized.	"ensure they are different objects"
	serialized2 := STON fromString: str.
	materialized := serializer materializeDiagram: serialized2.

	self assert: materialized elements size = 2.
	self assert: materialized elements first dcID = el1 dcID.
	self assert: materialized elements second dcID = el2 dcID