rendering
updateFor: anElement trachelShape: trachelShape
	| c s txt |
	trachelShape isNil
		ifTrue: [ ^ self ].
	s := nil.
	c := self colorFor: anElement.
	trachelShape
		color: c;
		position: (self positionFor: anElement).
	txt := self textFor: anElement.
	trachelShape text: txt on: (self positionFor: anElement)