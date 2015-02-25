public
offsetNormalFor: anEdge
	"Return the offset in case of multiple edges with the same starting and ending points"

	^ (RTShorterDistanceWithOffsetAttachPoint new offset: offset) offsetNormalFor: anEdge