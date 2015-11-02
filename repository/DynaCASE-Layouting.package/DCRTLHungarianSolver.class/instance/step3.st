algorithm
step3
	| min |
	min := self nonCoveredMin.
	rowCovers
		withIndexDo: [ :covered :i | 
			covered
				ifTrue: [ self addToRowAt: i value: min ] ].
	columnCovers
		withIndexDo:
			[ :covered :j | 
			covered
				ifFalse: [ self addToColumnAt: j value: min negated ] ].
	self step1