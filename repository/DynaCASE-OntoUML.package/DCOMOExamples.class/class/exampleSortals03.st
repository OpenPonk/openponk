examples
exampleSortals03
	| project model person man woman living deceased aLayout |
	project := DCProject new.
	model := DCOmlDiagram new name: 'World W'.
	person := Kind name: 'Person' metaModel: model.
	man := SubKind name: 'Man' metaModel: model.
	woman := SubKind name: 'Woman' metaModel: model.
	living := Phase name: 'LivingPerson' metaModel: model.
	deceased := Phase name: 'DeceasedPerson' metaModel: model.
	model
		add:
				(Generalization new
						parent: person;
						child: man);
		add:
				(Generalization new
						parent: person;
						child: woman);
		add:
				(Generalization new
						parent: person;
						child: living);
		add:
				(Generalization new
						parent: person;
						child: deceased).
	aLayout := Dictionary new.
	aLayout
		at: person put: 32.5 @ 21.0;
		at: man put: -7 @ 136;
		at: woman put: 79 @ 136;
		at: living put: 260 @ -10;
		at: deceased put: 275 @ 40;
		at: deceased put: 275 @ 40.
	project addDiagram: model.
	project layouts: (Dictionary new at: model put: aLayout).
	DCWorkbench openProject: project