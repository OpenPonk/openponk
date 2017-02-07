building
addGrip
	gripElement := gripShape element.
	element view add: gripElement.
	gripEdge := gripLine edgeFrom: element to: gripElement.
	element view add: gripEdge