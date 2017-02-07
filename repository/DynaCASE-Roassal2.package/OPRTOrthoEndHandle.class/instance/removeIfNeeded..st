as yet unclassified
removeIfNeeded: aCorner
	(self isInsideEndElement: aCorner position)
		ifTrue: [ self removeNeighborCorner ]