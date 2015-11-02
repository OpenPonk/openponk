as yet unclassified
showSolutionSpaceForLabel: aLabel edge: anEdge
	| line space polygon |
	(anEdge hasAttribute: #solutionSpace)
		ifTrue:
			[ (anEdge attributeAt: #solutionSpace) remove.
			anEdge view signalUpdate.
			anEdge removeAttributeAt: #solutionSpace.
			^ self ].
	line := RTLineSegment
		from: (anEdge shape startingPointOf: anEdge)
		to: (anEdge shape endingPointOf: anEdge).
	space := self computeSolutionSpaceFor: aLabel encompassingRectangle line: line.
	polygon := RTPolygon new
		color: Color green;
		vertices: space;
		element.
	anEdge view add: polygon.
	polygon trachelShape pushBack.
	anEdge view signalUpdate.
	anEdge attributeAt: #solutionSpace put: polygon