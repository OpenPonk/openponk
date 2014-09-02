instance creation
example3
	| diagram firstClass secondClass a1 |
	diagram := DCUmliteDiagram new.
	firstClass := DCUmliteClass new name: 'FirstClass'.
	firstClass
		attributes:
			'-attr1
-attr2' lines asOrderedCollection.
	secondClass := DCUmliteClass new
		name: 'SecondClass';
		attributes: '-attrX' lines asOrderedCollection;
		yourself.
	a1 := DCUmliteAssociation from: firstClass to: secondClass.
	diagram
		add: firstClass;
		add: secondClass;
		add: a1.
	^ self openOn: diagram