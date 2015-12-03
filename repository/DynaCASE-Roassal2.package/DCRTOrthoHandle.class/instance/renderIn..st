rendering
renderIn: aView
	element := self shape element.
	aView add: element.
	element addConnectedEdge: edge.
	element translateTo: self position