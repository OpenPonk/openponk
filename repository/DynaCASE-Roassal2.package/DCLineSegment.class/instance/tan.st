geometry
tan
	| vector |
	vector := self vector.
	vector x isZero
		ifTrue: [ ^ nil ].
	^ vector y / vector x