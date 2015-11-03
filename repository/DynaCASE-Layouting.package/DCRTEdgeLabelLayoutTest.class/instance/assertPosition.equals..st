asserting
assertPosition: actual equals: expected
	#(#ranking #maxRanking #position #orientation #bounds)
		do: [ :each | self assert: (actual perform: each) equals: (expected perform: each) ]