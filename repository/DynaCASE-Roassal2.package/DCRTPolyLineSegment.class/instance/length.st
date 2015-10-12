accessing
length
	^ self segments inject: 0 into: [ :sum :next | sum + next length ]