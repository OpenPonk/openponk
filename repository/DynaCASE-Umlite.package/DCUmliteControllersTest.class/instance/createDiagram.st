as yet unclassified
createDiagram
	| umlite c1 c2 c3 c4 a1 a2 a3 a4 |
	umlite := DCUmliteDiagram  new.
	c1 := DCUmliteClass new.
	c2 := DCUmliteClass new.
	c3 := DCUmliteClass new.
	c4 := DCUmliteClass new.
	umlite 
		add: c1;
		add: c2;
		add: c3;
		add: c4.
	a1 := DCUmlAssociation from: c1 to: c2.
	a2 := DCUmlAssociation from: c2 to: c3.
	a3 := DCUmlAssociation from: c3 to: c1.
	a4 := DCUmlAssociation from: c3 to: c4.
	umlite
		add: a1;
		add: a2;
		add: a3;
		add: a4.
	^ umlite