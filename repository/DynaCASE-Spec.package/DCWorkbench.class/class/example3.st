examples
example3
	| diagram firstClass secondClass a1 project |
	project := DCProject new projectName: 'Example Umlite'.
	diagram := DCUmliteDiagram new.
	project addDiagram: diagram.
	firstClass := DCUmliteClass new name: 'FirstClass'.
	firstClass attributes: #('-attr1' '-attr2') asOrderedCollection.
	secondClass := DCUmliteClass new
		name: 'SecondClass';
		attributes: #('-attrX') asOrderedCollection;
		yourself.
	(a1 := DCUmliteAssociation from: firstClass to: secondClass)
		name: 'association';
		sourceName: '+firstClass[1]';
		targetName: '+secondClass[1..*]'.
	diagram
		add: firstClass;
		add: secondClass;
		add: a1.
	^ self openProject: project