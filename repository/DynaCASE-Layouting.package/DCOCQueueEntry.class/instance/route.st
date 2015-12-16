accessing
route
	| route step |
	route := OrderedCollection new.
	step := self.
	[ step ]
		whileNotNil: [ route add: step node model.
			step := step parent ].
	^ route reversed