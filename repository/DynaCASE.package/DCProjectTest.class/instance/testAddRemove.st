tests
testAddRemove
	| project diagram |
	diagram := DCDiagram new.
	project := DCProject new.
	self assert: project models isEmpty.

	project addModel: diagram.
	self assert: project models size = 1.

	project removeModel: diagram.
	self assert: project models isEmpty