rendering
updateFor: anElement trachelShape: trachelShape
	trachelShape isNil
		ifTrue: [ ^ self ].
	trachelShape position: anElement position