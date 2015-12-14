as yet unclassified
partition: aGraph ordering: anOrdering
	| overlap left right rest |
	overlap := self overlapGraphFor: aGraph ordering: anOrdering.
	left := self independentSetFor: overlap.
	right := self
		independentSetFor: (overlap vertexInducedBy: (overlap nodes copyWithoutAll: left)).
	rest := overlap nodes copyWithoutAll: left , right.
	^ {left.
	right.
	rest}