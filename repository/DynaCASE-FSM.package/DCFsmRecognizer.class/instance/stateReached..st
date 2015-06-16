events
stateReached: aState
	^ self announce: (DCFsmStateReached state: aState transition: transition)