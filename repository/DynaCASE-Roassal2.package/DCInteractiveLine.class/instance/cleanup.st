accessing
cleanup
	running
		ifTrue: [ 
			running := false.
			view announcer unsubscribe: moveSubscription.
			mouseBox remove.
			line remove.
			view signalUpdate ]