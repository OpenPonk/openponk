as yet unclassified
connectionLength
	^ self segments inject: 0 into: [ :sum :each | sum + (each first dist: each second) ]