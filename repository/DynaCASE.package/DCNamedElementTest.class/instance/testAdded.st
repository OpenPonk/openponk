tests
testAdded
	| diagram el |
	diagram := DCDiagram new.
	el := DCNamedElement new.

	diagram add: el.
	self assert: el owner = diagram