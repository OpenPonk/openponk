as yet unclassified
trachelShapeFor: anEdge from: aPoint
	^ self
		trachelShapeFor: anEdge
		from: aPoint
		to:
			(tail
				ifFalse: [ attachPoint endingPointOf: anEdge ]
				ifTrue: [ attachPoint startingPointOf: anEdge ])