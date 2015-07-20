tests
testAddRemove
	| project diagram |
	diagram := DCDiagram new.
	project := DCProject new.
	self assert: project diagrams isEmpty.

	project addDiagram: diagram.
	self assert: project diagrams size = 1.

	project removeDiagram: diagram.
	self assert: project diagrams isEmpty