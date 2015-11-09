as yet unclassified
initialPositions
	^ (self labels collect: [ :each | each -> (self initialPositionsFor: each) ])
		as: OrderedDictionary