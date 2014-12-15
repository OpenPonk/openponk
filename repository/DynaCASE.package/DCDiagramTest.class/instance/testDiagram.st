tests
testDiagram
	| diagram changed |
	diagram := DCDiagram new name: 'name'.
	changed := false.
	diagram whenChanged: [ changed := true ].
	diagram name: 'changed name'.
	self assert: changed.
	self assert: diagram name = 'changed name'