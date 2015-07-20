examples
"protocol: examples"
exampleSortals03
	| project model person man woman living deceased aLayout gen1 gen2|
	project := DCProject new.
	model := DCOmlDiagram new name: 'Example diagram'.
	person := Kind name: 'Person' metaModel: model.
	man := SubKind name: 'Man' metaModel: model.
	woman := SubKind name: 'Woman' metaModel: model.
	living := Phase name: 'LivingPerson' metaModel: model.
	deceased := Phase name: 'DeceasedPerson' metaModel: model.
	gen1 := GeneralizationSet new.
	gen2 := GeneralizationSet new.
	model
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
		at: deceased put: 275 @ 40;
		at: deceased put: 275 @ 40.
	project addDiagram: model.
	project layouts: (Dictionary new at: model put: aLayout).
	DCWorkbench openProject: project