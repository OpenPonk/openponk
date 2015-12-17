hook
positionFrom: aStringPair
	| pos |
	pos := aStringPair splitOn: ','.
	^ pos first asNumber @ pos second asNumber