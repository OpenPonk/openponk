tests-materializing
testMaterializeElement
	| e materialized |
	e := DCNamedElement new name: 'Some Element'.

	materialized := serializer materializeElement: e.
	self assert: materialized = e