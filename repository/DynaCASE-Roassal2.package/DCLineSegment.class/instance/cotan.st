geometry
cotan
	| vector |
	vector := self vector.
	vector y isZero
		ifTrue: [ ^ nil ].
	^ vector x / vector y