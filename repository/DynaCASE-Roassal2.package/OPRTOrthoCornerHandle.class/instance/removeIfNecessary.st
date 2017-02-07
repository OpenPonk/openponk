removing
removeIfNecessary
	(self hasPredecessor and: [ self previous isEnd ])
		ifTrue: [ self previous removeIfNeeded: self ].
	(self hasSuccessor and: [ self next isEnd ])
		ifTrue: [ self next removeIfNeeded: self ]