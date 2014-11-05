tests
testDiagram
	| diagram |
	diagram := DCDiagram new.
	diagram nameHolder whenChangedDo: [ :newName | self assert: newName = 'a name' ].
	diagram name: 'a name'.
	self assert: diagram name = 'a name'