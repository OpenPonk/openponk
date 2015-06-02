examples
exampleSortals03
	| project model person man woman living deceased aLayout gen1 gen2 params quantity kind |
	project := DCProject new.
	model := DCOmlDiagram new name: 'Example diagram'.
	person := Kind new name: 'Person1'.
	
	params := OrderedCollection new.
	params add: 'x'; add: 'y'; add: 'z'.
	Attribute name: 'firstName' dataType: 'string' multiplicity: '1' element: person.
	Attribute name: 'surname' dataType: 'string' multiplicity: '1' element: person.
	Attribute name: 'age' dataType: 'int' multiplicity: '0..1' element: person.
	Method new name: 'calc'; returnDataType: 'int'; element: person; parameters: params.
	
	man := SubKind new name: 'Man'.
	woman := SubKind new name: 'Woman'.
	living := Phase new name: 'LivingPerson'.
	deceased := Phase new name: 'DeceasedPerson'.
	gen1 := GeneralizationSet new.
	gen2 := GeneralizationSet new.
	
	quantity := Quantity new name: 'TestQuantity'.
	kind := Kind new name: 'TestKind'.
	
		
	model
		add: (FormalAssociation 
					name: 'containment'
					start: quantity
					startMultiplicity: '1'
					end: kind
					endMultiplicity: '1');
		add:
				(Generalization parent: person child: man generalizationSet: gen1);
		add:
				(Generalization parent: person child: woman generalizationSet: gen1);

		add:
				(Generalization parent: person child: living generalizationSet: gen2);
		add:
				(Generalization parent: person child: deceased generalizationSet: gen2).
		
	aLayout := Dictionary new.
	aLayout
		at: person put: 32.5 @ 21.0;
		at: man put: -100 @ 156;
		at: woman put: 79 @ 136;
		at: living put: 260 @ -10;
		at: quantity put: 200 @ -20;
		at: kind put: 150 @ -10;
		at: deceased put: 275 @ 40.
		
	project addDiagram: model.
	project layouts: (Dictionary new at: model put: aLayout).
	DCWorkbench openProject: project