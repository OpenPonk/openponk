helpers
anyNonCoveredZero
	matrix
		withIndicesDo:
			[ :val :i :j | 
			val = 0 & (rowCovers at: i) not & (columnCovers at: j) not
				ifTrue: [ ^ i @ j ] ].
	^ nil