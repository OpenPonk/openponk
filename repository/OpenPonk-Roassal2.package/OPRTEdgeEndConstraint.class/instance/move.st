running
move
	"moves shape according to edge positions and settings"

	| startPoint endPoint vector distVector |
	startPoint := edge shape startingPointOf: edge.
	endPoint := edge shape endingPointOf: edge.
	shape
		translateTo:
			(origin = #start
				ifTrue: [ startPoint ]
				ifFalse: [ endPoint ]).
	(vector := endPoint - startPoint) isZero
		ifFalse: [ 
			distVector := distance * vector normalized.
			origin = #end
				ifTrue: [ distVector := distVector negated ].
			shape translateBy: vector normal * offset + distVector ]