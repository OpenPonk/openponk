cost
penaltyForEdgeProximity: aPosition of: anEdge
	| line closestAnotherDistance edgeDistance from to |
	from := [ :e | e shape startingPointOf: e ].
	to := [ :e | e shape endingPointOf: e ].
	line := RTLineSegment from: (from value: anEdge) to: (to value: anEdge).
	closestAnotherDistance := ((edges copyWithout: anEdge)
		collect:
			[ :each | 
			(aPosition bounds nearestDistanceToLineFrom: (from value: each) to: (to value: each))
				rounded ]) ifEmpty: [ -1000 ] ifNotEmpty: [ :c | c min ].
	edgeDistance := (aPosition bounds nearestDistanceToLineFrom: line from to: line to)
		rounded.
	^ 11 - closestAnotherDistance rounded max: 0
	"^ closestAnotherDistance > 10
		ifTrue: [ 0 ]
		ifFalse: [ 1.5 ]"
	"^ closestAnotherDistance > 0
		ifTrue: [ edgeDistance / closestAnotherDistance ]
		ifFalse: [ 1 ]"