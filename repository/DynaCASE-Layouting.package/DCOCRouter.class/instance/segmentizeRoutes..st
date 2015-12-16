as yet unclassified
segmentizeRoutes: routes
	| segments |
	segments := Dictionary new.
	routes
		withIndexDo:
			[ :route :i | 
			route
				overlappingPairsDo: [ :a :b | (segments at: a -> b ifAbsentPut: [ OrderedCollection new ]) add: i ] ].
	^ segments