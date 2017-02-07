running
setUp
	super setUp.
	adapter := self adapterClass new.
	diagram := OPDiagram named: 'Default Diagram'.
	element := OPNamedElement named: 'Default Element'.
	edge := (OPEdge from: element to: element) name: 'Default Edge'.
	diagram
		add: element;
		add: edge