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

	project addDiagram: model.
	^ project