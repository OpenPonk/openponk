hook
edgeLayoutToRoute: anEdge
	^ "DCOCRouter
		collinearizeRoute:"
			(((anEdge xPath: 'attr[@name="pos"]') first contentString splitOn: ' ')
				collect: [ :each | self positionFrom: each ])