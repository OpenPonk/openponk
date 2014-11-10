public - moving
move: aShape near: origin ofEdge: anEdge distance: aNumber offset: anotherNumber
	| vector startPoint endPoint |
	startPoint := anEdge shape startingPointOf: anEdge.
	endPoint := anEdge shape endingPointOf: anEdge.
	aShape
		translateTo:
			(origin = #start
				ifTrue: [ startPoint ]
				ifFalse: [ endPoint ]).
	(vector := endPoint - startPoint) isZero
		ifFalse: [ 
			aShape
				translateBy: vector normal * anotherNumber;
				translateBy:
						(origin = #start
								ifTrue: [ 1 ]
								ifFalse: [ -1 ]) * vector normalized * aNumber ].
	^ aShape