accessing
segmentWithPointFor: aNumber
	| sum newSum balance |
	sum := 0.
	balance := self absoluteBalanceFor: aNumber.
	self segments
		do:
			[ :each | 
			newSum := sum + each length.
			(balance between: sum and: newSum)
				ifTrue: [ 
					^ {each.
					(each pointForBalance: balance - sum)} ].
			sum := newSum ].
	self error: 'failed to find a segment'