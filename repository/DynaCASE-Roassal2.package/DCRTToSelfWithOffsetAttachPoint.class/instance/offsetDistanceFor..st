public
offsetDistanceFor: anEdge
	"Return the offset in case of multiple edges"

	| indexOfEdge multipleEdges |
	multipleEdges := OrderedCollection new.
	(anEdge to connectedEdges select: [ :e | e from == e to ]) do: [ :e | multipleEdges addIfNotPresent: e ].
	indexOfEdge := multipleEdges indexOf: anEdge.
	^ (indexOfEdge - 1) * offset