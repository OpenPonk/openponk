algorithm
step1
	| indices |
	self isComplete
		ifTrue: [ ^ self done ].
	[ indices := self anyNonCoveredZero ]
		whileNotNil:
			[ marks at: indices x at: indices y put: self prime.
			(self rowHasStar: indices x)
				ifNil: [ ^ self step2: indices ]
				ifNotNil: [ :j | 
					rowCovers at: indices x put: true.
					columnCovers at: j put: false ] ].
	self step3