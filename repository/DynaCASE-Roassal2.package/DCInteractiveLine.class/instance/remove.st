accessing
remove
	running
		ifFalse: [ ^ self ].
	running := false.
	view announcer unsubscribe: moveSubscription.
	mouseBox remove.
	line remove.
	view signalUpdate