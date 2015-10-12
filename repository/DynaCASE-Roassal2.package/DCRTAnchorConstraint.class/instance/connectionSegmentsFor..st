as yet unclassified
connectionSegmentsFor: anEdge
	^ (anEdge shape pathFor: anEdge)
		overlappingPairsCollect: [ :from :to | RTLineSegment from: from to: to ]