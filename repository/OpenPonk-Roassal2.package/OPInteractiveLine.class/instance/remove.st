accessing
remove
	running
		ifTrue: [ 
			running := false.
			view announcer unsubscribe: moveSubscription.
			mouseBox remove.
			view signalUpdate ]