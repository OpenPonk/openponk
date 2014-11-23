examples
exampleAgregations07
	| project model car engine passengers |
	project := DCProject new.
	model := DCOmlDiagram new.
	car := Kind name: 'Car' metaModel: model.
	engine := Kind name: 'Engine' metaModel: model.
	passengers := Collective name: 'Passengers' metaModel: model.
	model
		add:
				(ComponentOf
						name: 'componentOf'
						start: engine
						startMultiplicity: 1
						end: car
						endMultiplicity: 1);
		add:
				(MemberOf
						name: 'memberOf'
						start: passengers
						startMultiplicity: '*'
						end: car
						endMultiplicity: '0..1').
	project addDiagram: model.

	DCWorkbench openProject: project