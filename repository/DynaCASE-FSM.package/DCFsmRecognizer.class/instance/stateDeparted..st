events
stateDeparted: aState
	^ self announce: (DCFsmStateDeparted state: aState transition: transition)