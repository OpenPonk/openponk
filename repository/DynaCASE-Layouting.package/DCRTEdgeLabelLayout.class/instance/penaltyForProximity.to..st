as yet unclassified
penaltyForProximity: aPosition to: anEdge
	| line |
	line := RTLineSegment
		from: (anEdge shape startingPointOf: anEdge)
		to: (anEdge shape endingPointOf: anEdge).
	^ (aPosition center dist: (aPosition center nearestPointOnLineFrom: line from to: line to))
		rounded