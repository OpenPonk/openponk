accessing
segmentsForConnection: aConnection
	^ (aConnection shape pathFor: aConnection)
		overlappingPairsCollect: [ :a :b | Array with: a with: b ]