helpers
nonCoveredMin
	| min |
	min := Float infinity.
	matrix
		withIndicesDo:
			[ :val :i :j | 
			(rowCovers at: i) not & (columnCovers at: j) not & (val < min)
				ifTrue: [ min := val ] ].
	^ min