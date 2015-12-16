as yet unclassified
distanceTo: aNode
	"Manhattan distance between two nodes."

	^ (self model x - aNode model x) abs + (self model y - aNode model y) abs