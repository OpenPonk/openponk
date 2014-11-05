tests
testRemoved
	| diagram el |
	diagram := DCDiagram new.
	el := DCNamedElement new.
	diagram add: el.

	diagram remove: el.
	self assert: el owner isNil