as yet unclassified
edgeMarksFor: anEdge
	| line angle direction |
	line := RTLineSegment
		from: (anEdge shape startingPointOf: anEdge)
		to: (anEdge shape endingPointOf: anEdge).
	angle := line vector angle.
	direction := angle cos @ angle sin.
	^ ((OrderedCollection with: line from + (15 * direction))
		,
			((1 to: line length / self spacing)
				collect: [ :i | line from + (i * self spacing * direction) ])
		, {(line to - (15 * direction))} collect: [ :each | each rounded ]) removeDuplicates
		asArray