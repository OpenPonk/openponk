tests
testCreateDiagram
	| fsm |
	fsm := self createDiagram.
	self assert: fsm elements size = 8