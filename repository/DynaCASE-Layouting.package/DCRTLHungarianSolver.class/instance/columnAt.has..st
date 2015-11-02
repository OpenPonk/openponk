helpers
columnAt: j has: aMark
	(marks atColumn: j)
		withIndexDo: [ :each :i | 
			each = aMark
				ifTrue: [ ^ i ] ].
	^ nil