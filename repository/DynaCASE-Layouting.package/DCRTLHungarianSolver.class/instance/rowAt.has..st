helpers
rowAt: i has: aMark
	(marks atRow: i)
		withIndexDo: [ :each :j | 
			each = aMark
				ifTrue: [ ^ j ] ].
	^ nil