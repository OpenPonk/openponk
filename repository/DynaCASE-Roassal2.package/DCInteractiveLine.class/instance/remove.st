accessing
remove
	running
		ifTrue: [ 
			running := false.
			view announcer unsubscribe: moveSubscription.
			line remove. "unnecessary in latest (13th July 15) Roassal"
			mouseBox remove.
			view signalUpdate ]