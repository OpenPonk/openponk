examples
exampleSortals03
	| project model person man woman living deceased |
	project := DCProject new.
	model := DCOmlDiagram new name: 'World W'.
	person := Kind name: 'Person' metaModel: model.
	man := SubKind name: 'Man' metaModel: model.
	woman := SubKind name: 'Woman' metaModel: model.
	living := Phase name: 'LivingPerson' metaModel: model.
	deceased := Phase name: 'DeceasedPerson' metaModel: model.
	model
		add: (ParentClass parentClass: person child: man);
		add: (ParentClass parentClass: person child: woman);
		add: (ParentClass parentClass: person child: living);
		add: (ParentClass parentClass: person child: deceased).
	layout := Dictionary new.
	layout
		at: person put: 32.5 @ 21.0;
		at: man put: -7 @ 136;
		at: woman put: 79 @ 136;
		at: living put: 260 @ -10;
		at: deceased put: 275 @ 40;
		at: deceased put: 275 @ 40.
	project addDiagram: model.
	project layouts: (Dictionary new at: model put: layout).
	^ project