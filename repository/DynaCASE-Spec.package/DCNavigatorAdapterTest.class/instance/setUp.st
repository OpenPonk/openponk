running
setUp
	super setUp.
	adapter := self adapterClass new.
	diagram := DCDiagram named: 'Default Diagram'.
	element := DCNamedElement named: 'Default Element'.
	edge := (DCEdge from: element to: element) name: 'Default Edge'.
	diagram
		add: element;
		add: edge