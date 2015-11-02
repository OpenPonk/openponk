as yet unclassified
edgeMarksFor: anEdge
	| line angle |
	line := RTLineSegment
		from: (anEdge shape startingPointOf: anEdge)
		to: (anEdge shape endingPointOf: anEdge).
	angle := line vector angle.
	^ (Set with: line from with: line to)
		,
			((0 to: line length / self spacing)
				collect: [ :i | line from + (i * self spacing * (angle cos @ angle sin)) ])