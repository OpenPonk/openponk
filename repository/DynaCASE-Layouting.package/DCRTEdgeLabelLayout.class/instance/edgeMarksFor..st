as yet unclassified
edgeMarksFor: anEdge
	| line angle |
	line := RTLineSegment
		from: (anEdge shape startingPointOf: anEdge)
		to: (anEdge shape endingPointOf: anEdge).
	angle := line vector angle.
	^ ((OrderedCollection with: line from)
		,
			((0 to: line length / self spacing)
				collect: [ :i | line from + (i * self spacing * (angle cos @ angle sin)) ]) , {line to})
		removeDuplicates asArray