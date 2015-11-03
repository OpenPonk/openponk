as yet unclassified
indexPositions: aDictionary
	"assign each position a globally (within the view) unique ID so it can be tracked later"

	| indexed i |
	indexed := OrderedDictionary new.
	i := 0.
	aDictionary
		keysAndValuesDo:
			[ :label :positions | 
			indexed
				at: label
				put:
					(positions asArray
						collect:
							[ :each | 
							i := i + 1.
							DCRTLPositionNode new
								model: each;
								index: i;
								yourself ]) ].
	^ indexed