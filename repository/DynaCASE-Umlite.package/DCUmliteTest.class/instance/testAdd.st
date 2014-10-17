tests
testAdd
	| umlite c1 c2 a |
	umlite := DCUmliteDiagram new.
	self assert: umlite elements size = 0.

	c1 := DCUmliteClass  new name: '1'.
	umlite add: c1.
	c2 := DCUmliteClass new name: '2'.
	umlite add: c2.
	self assert: umlite elements size = 2.
	self assert: umlite elements first owner = umlite.

	a := DCUmliteAssociation from: umlite elements first to: umlite elements second.
	umlite add: a.
	self assert: umlite elements size = 3.
	self assert: umlite elements third owner = umlite.