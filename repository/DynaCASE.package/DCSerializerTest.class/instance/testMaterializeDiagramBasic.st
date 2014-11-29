tests-materializing
testMaterializeDiagramBasic
	| d materialized id |
	id := UUID new.
	d := Dictionary new.
	d at: #name put: 'Some Diagram'.
	d at: #className put: 'DCDiagram'.
	d at: #dcID put: id.

	materialized := serializer materializeDiagramBasic: d.
	self assert: (materialized isKindOf: DCDiagram).
	self assert: materialized name = 'Some Diagram'.
	self assert: materialized dcID = id