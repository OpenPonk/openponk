tests
testRemoveComplex
	| diagram c1 c2 c3 c4 a1 a2 a3 a4 |
	diagram := DCUmliteDiagram  new.
	c1 := DCUmliteClass  new.
	c2 := DCUmliteClass new name: '1'.
	c3 := DCUmliteClass new name: '2'.
	c4 := DCUmliteClass new name: '3'.
	diagram
		add: c1;
		add: c2;
		add: c3;
		add: c4.
	a1 := DCUmliteAssociation  from: c1 to: c2.
	(a2 := DCUmliteAssociation from: c2 to: c3) name: 'a'.
	(a3 := DCUmliteAssociation from: c3  to: c2) name: 'b'.
	(a4 := DCUmliteAssociation from: c3 to:  c4) name: 'a'.
	diagram
		add: a1;
		add: a2;
		add: a3;
		add: a4.
	self assert: diagram elements size = 8.
	diagram remove: c2.
	self assert: diagram elements size = 4.
	diagram remove: c1.
	diagram remove: c4.
	self assert: diagram elements size = 1