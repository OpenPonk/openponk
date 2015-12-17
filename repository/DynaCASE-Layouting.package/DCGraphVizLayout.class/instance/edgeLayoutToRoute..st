hook
edgeLayoutToRoute: anEdge
	^ DCOCRouter
		collinearizeRoute:
			((ASPathConverter new stream: ((anEdge // #path) first attributeAt: #d) readStream)
				convertPathData flatCollect: #second)