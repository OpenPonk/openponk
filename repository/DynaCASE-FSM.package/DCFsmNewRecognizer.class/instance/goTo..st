private
goTo: aPlace
	current ifNotNil: [ self announce: (DCFsmRecognizerLeave place: current) ].
	current := aPlace.
	self announce: (DCFsmRecognizerEnter place: current)