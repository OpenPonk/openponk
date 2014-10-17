tests
testRemoveClass
	| diagram c1 c2 a |
	diagram := DCUmliteDiagram  new.
	c1 := DCUmliteClass  new name: '1'.
	c2  := DCUmliteClass new name: '2'.
	a := DCUmliteAssociation  from: c1 to: c2.

	diagram add: c1.
	diagram add: c2.
	diagram add: a.
	self assert: diagram elements size = 3.

	diagram remove: c1.
	self assert: diagram elements size = 1.
	self assert: c1 associations size = 0.
	self assert: c2 associations size = 0