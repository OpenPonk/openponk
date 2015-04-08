tests
testAddRemove
	| project diagram |
	project := DCProject new.
	self assert: project diagrams isEmpty.
	diagram := DCDiagram new.
	project addDiagram: diagram.
	self assert: project diagrams size = 1.
	project removeDiagram: diagram.
	self assert: project diagrams isEmpty