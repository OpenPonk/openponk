examples
exampleSimple
"
	| project diagram obj el dia proj |
	project := DCProject named: 'UML Class Diagram'.
	diagram := DUmlClassDiagram named: 'UML Class Diagram'.
	project addDiagram: diagram.
	proj := DUmlClass named: 'DCProject'.
	dia := DUmlClass named: 'DCDiagram'.
	el := DUmlClass named: 'DCNamedElement'.
	obj := DUmlClass named: 'DCModelObject'.
	obj attributes: #('+dcID: string' '+dcName: string').

	diagram
		add: proj;
		add: dia;
		add: el;
		add: obj.

	diagram
		add: (DUmlGeneralization from: el to: obj);
		add: (DUmlGeneralization from: dia to: obj);
		add:
				((DUmlAssociation from: dia to: el)
						sourceName: '+owner';
						sourceMultiplicity: '0..1';
						targetName: '+elements';
						targetMultiplicity: '*';
						yourself);
		add:
				((DUmlAssociation from: obj to: obj)
						targetName: '+owner';
						sourceMultiplicity: '*';
						targetMultiplicity: '0..1';
						yourself);
		add:
				((DUmlAssociation from: proj to: dia)
						targetName: '+diagrams';
						targetMultiplicity: '*';
						sourceMultiplicity: '0..1';
						yourself).

	DCWorkbench openProject: project"