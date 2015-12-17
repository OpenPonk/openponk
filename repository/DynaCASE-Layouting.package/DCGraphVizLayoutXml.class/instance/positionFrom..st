hook
positionFrom: aStringPair
	| pos |
	pos := ((aStringPair beginsWith: 'e,')
		ifTrue: [ aStringPair allButFirst: 2 ]
		ifFalse: [ aStringPair ]) splitOn: ','.
	^ pos first asNumber @ pos second asNumber