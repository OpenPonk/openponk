instance creation
addSegmentHandlesTo: list
	| b |
	list asArray
		overlappingPairsDo: [ :a :c | 
			b := self newHandleBetween: a and: c.
			b position: (a position + c position) / 2.
			list add: b afterLink: a ]