as yet unclassified
initialPositions
	^ (self batchOfUnassignedLabels
		collect: [ :each | each -> (self initialPositionsFor: each) ]) as: OrderedDictionary