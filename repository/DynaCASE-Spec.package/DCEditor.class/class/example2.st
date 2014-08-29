instance creation
example2
	| diagram firstClass secondClass |
	diagram := DCUmlClassDiagram new.
	firstClass := DCUmlClass new name: 'FirstClass'.
	firstClass
		addAttribute:
				(DCUmlAttribute new
						name: 'firstAttr';
						type: 'mixed';
						yourself);
		addAttribute:
				(DCUmlAttribute new
						name: 'secondAttr';
						type: 'mixed';
						yourself).
	secondClass := DCUmlClass new name: 'SecondClass'.
	diagram
		add: firstClass;
		add: secondClass.
	^ self openOn: diagram