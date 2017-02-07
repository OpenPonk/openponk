as yet unclassified
segmentForPosition: aPosition
	| sum newSum |
	sum := 0.
	self segments
		do:
			[ :each | 
			newSum := sum + (each first dist: each second).
			sum <= aPosition & (aPosition <= newSum)
				ifTrue:
					[ 
					^ {each first.
					each second.
					(self pointBetween: each first and: each second distance: aPosition - sum)} ].
			sum := newSum ].
	self error: 'failed to find a segment'