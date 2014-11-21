as yet unclassified
offsetDistanceFor: anEdge
	"Return the offset in case of multiple edges with the same starting and ending points"

	| indexOfEdge multipleEdges |
	multipleEdges := OrderedCollection new.
	(anEdge to connectedEdges select: [ :e | e from == e to ]) do: [ :e | multipleEdges addIfNotPresent: e ].
	indexOfEdge := multipleEdges indexOf: anEdge.
	^ (indexOfEdge - 1) * offset